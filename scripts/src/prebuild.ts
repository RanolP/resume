#!/usr/bin/env bun
import { $ } from "bun";
import path from "node:path";

$.cwd(path.resolve(import.meta.dir, "../../"));
await $`./scripts/src/reset.ts`;
await $`./scripts/src/fetch-github-metadata.ts`;
await $`./scripts/src/fetch-solved-metadata.ts`;
await $`./scripts/src/download-icons.ts`;
