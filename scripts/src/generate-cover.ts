#!/usr/bin/env bun

import { $ } from "bun";

await $`mkdir cover`.quiet();
await $`typst compile cover.typ cover/page-dark-{n}.svg --input theme=dark -f svg`;
await $`typst compile cover.typ cover/page-light-{n}.svg --input theme=light -f svg`;
