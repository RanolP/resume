#!/usr/bin/env bun
import { $ } from 'bun';
import path from 'node:path';

$.cwd(path.resolve(import.meta.dir, '../../'));
await $`mkdir cover`.quiet().nothrow();
console.log('    for dark theme...');
await $`typst compile cover.typ cover/page-dark-{n}.svg --input theme=dark -f svg`;
console.log('    for light theme...');
await $`typst compile cover.typ cover/page-light-{n}.svg --input theme=light -f svg`;
console.log('done!');
process.exit(0);
