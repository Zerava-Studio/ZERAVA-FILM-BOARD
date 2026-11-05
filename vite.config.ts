
import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

export default defineConfig({
  plugins: [react()],
  base: '/ZERAVA-FILM-BOARD/',
  build: {
    outDir: 'dist'
  }
});
