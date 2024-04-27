#!/usr/bin/env bun
import { $ } from "bun";
import path from "node:path";

$.cwd(path.resolve(import.meta.dir, "../../"));
await $`mkdir -p assets/.automatic/icon/`;
await $`mkdir -p assets/.automatic/github/`;
await $`mkdir -p assets/.automatic/solved/`;
for (const file of [
  "icon/manifest.json",
  "github/pull.json",
  "github/issue.json",
  "solved/user.json",
]) {
  const data = await $`cat assets/.automatic/${file}`
    .quiet()
    .json()
    .catch(() => ({}));
  await $`echo ${JSON.stringify(data)} > assets/.automatic/${file}`;
}
