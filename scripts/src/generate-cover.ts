#!/usr/bin/env bun

import { $ } from "bun";

await $`mkdir cover`.quiet();
await $`typst compile cover.typ cover/page-{n}.svg -f svg`;
await $`sed -e s/#000000/currentColor/ -i cover/page-*.svg`;
