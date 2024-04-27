#!/usr/bin/env bun
import { $ } from "bun";
import { parse, stringify } from "node:querystring";
import path from "node:path";

$.cwd(path.resolve(import.meta.dir, "../../"));
await $`mkdir -p assets/.automatic/icon/`;

const icons: string[] = (
  await Promise.all(
    [
      ["resume.typ"],
      ["cover.typ", "--input", "theme=light"],
      ["cover.typ", "--input", "theme=dark"],
    ].map((file) => $`typst query ${file} '<icon>' --field value`.json())
  )
).flat();

const data: Record<string, string> = {};
for (const icon of icons) {
  const {
    prefix,
    name,
    query: rawQuery,
  } = /(?<prefix>[\w-]+)\/(?<name>[\w-]+)(\?(?<query>\w+\=[\w#-]+(&\w+\=[\w#-]+)*))?/.exec(
    icon
  )?.groups ?? {};
  const query = parse(rawQuery);

  const filename = `${prefix}/${name}${
    query.color ? `-${query.color}` : ""
  }.svg`;
  const file = `assets/.automatic/icon/${filename}`;
  data[icon] = filename;
  if (await Bun.file(file).exists()) {
    continue;
  }

  const source = {
    "solved-ac": {
      get url() {
        const solveTier = /^solve-tier-(\d+)$/.exec(name);
        if (solveTier)
          return `https://static.solved.ac/tier_small/${solveTier[1]}.svg`;
        const arenaTier = /^arena-tier-(\d+)$/.exec(name);
        if (arenaTier)
          return `https://static.solved.ac/tier_arena/${arenaTier[1]}.svg`;

        throw new Error(`no icon found: ${icon}`);
      },
      name: "solvedac",
    },
  }[prefix] ?? {
    url: `https://api.iconify.design/${prefix}/${name}.svg?${stringify(query)}`,
    name: "iconify",
  };

  console.log(`Downloading ${icon} from ${source.name}`);

  await $`mkdir -p $(dirname ${file})`;
  await $`curl -Lf '${source.url}' > ${file}`.throws(true);
}

await $`echo ${JSON.stringify(data)} > assets/.automatic/icon/manifest.json`;
