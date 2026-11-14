// ============================================
// CLOUDFLARE WORKER FOR R2 FILE UPLOAD
// ============================================
// Deploy this worker to: upload.zerava.web.id
// R2 Bucket: zerava-storage
// Custom Domain: files.zerava.web.id
// API Token: Set in Cloudflare dashboard
// ============================================

export default {
  async fetch(request, env) {
    // Handle CORS preflight
    if (request.method === 'OPTIONS') {
      return handleCORS();
    }

    const url = new URL(request.url);
    
    // Health check endpoint
    if (url.pathname === '/health') {
      return new Response(JSON.stringify({ status: 'ok', service: 'zerava-upload-worker' }), {
        headers: { 'Content-Type': 'application/json' },
      });
    }

    // Upload endpoint
    if (request.method === 'POST' && url.pathname === '/upload') {
      return handleUpload(request, env);
    }

    // Delete endpoint
    if (request.method === 'DELETE' && url.pathname.startsWith('/delete/')) {
      const key = url.pathname.split('/delete/')[1];
      return handleDelete(key, env);
    }

    // Get endpoint
    if (request.method === 'GET' && url.pathname.startsWith('/get/')) {
      const key = url.pathname.split('/get/')[1];
      return handleGet(key, env);
    }

    return new Response('Not Found', { status: 404 });
  },
};

function handleCORS() {
  return new Response(null, {
    status: 204,
    headers: {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, HEAD, OPTIONS',
      'Access-Control-Allow-Headers': '*',
      'Access-Control-Max-Age': '86400',
    },
  });
}

async function handleUpload(request, env) {
  try {
    const formData = await request.formData();
    const file = formData.get('file');
    const key = formData.get('key') || generateKey(file.name);

    if (!file) {
      return errorResponse('No file provided', 400);
    }

    // Check file size (max 15MB)
    const maxSize = 15 * 1024 * 1024; // 15MB
    if (file.size > maxSize) {
      return errorResponse('File size exceeds 15MB limit', 413);
    }

    // Upload to R2
    await env.ZERAVA_STORAGE.put(key, file, {
      httpMetadata: {
        contentType: file.type,
      },
    });

    // Return public URL
    const publicUrl = `https://files.zerava.web.id/${key}`;
    
    return new Response(JSON.stringify({
      success: true,
      url: publicUrl,
      key: key,
      size: file.size,
    }), {
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
      },
    });

  } catch (error) {
    console.error('Upload error:', error);
    return errorResponse('Upload failed: ' + error.message, 500);
  }
}

async function handleDelete(key, env) {
  try {
    await env.ZERAVA_STORAGE.delete(key);
    return new Response(JSON.stringify({ success: true, key }), {
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
      },
    });
  } catch (error) {
    console.error('Delete error:', error);
    return errorResponse('Delete failed: ' + error.message, 500);
  }
}

async function handleGet(key, env) {
  try {
    const object = await env.ZERAVA_STORAGE.get(key);
    
    if (!object) {
      return errorResponse('File not found', 404);
    }

    const headers = new Headers();
    object.writeHttpMetadata(headers);
    headers.set('etag', object.httpEtag);
    headers.set('Access-Control-Allow-Origin', '*');

    return new Response(object.body, { headers });
  } catch (error) {
    console.error('Get error:', error);
    return errorResponse('Get failed: ' + error.message, 500);
  }
}

function errorResponse(message, status) {
  return new Response(JSON.stringify({ success: false, error: message }), {
    status,
    headers: {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': '*',
    },
  });
}

function generateKey(originalName) {
  const timestamp = Date.now();
  const random = Math.random().toString(36).substring(2, 8);
  const ext = originalName.split('.').pop();
  const name = originalName.replace(`.${ext}`, '').replace(/[^a-zA-Z0-9-_]/g, '_');
  return `${timestamp}_${random}_${name}.${ext}`;
}

// ============================================
// WRANGLER.TOML CONFIGURATION
// ============================================
/*
name = "zerava-upload-worker"
main = "cloudflare-worker-upload.js"
compatibility_date = "2024-01-01"

[[r2_buckets]]
binding = "ZERAVA_STORAGE"
bucket_name = "zerava-storage"

[vars]
ENVIRONMENT = "production"

[[routes]]
pattern = "upload.zerava.web.id"
custom_domain = true
*/
