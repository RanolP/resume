#!/usr/bin/env bun
import { $ } from "bun";

await $`./scripts/src/reset.ts`;
await $`./scripts/src/fetch-github-metadata.ts`;
await $`./scripts/src/fetch-solved-metadata.ts`;
await $`./scripts/src/download-icons.ts`;
