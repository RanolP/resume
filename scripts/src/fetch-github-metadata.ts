#!/usr/bin/env bun
import { $ } from "bun";

await $`mkdir -p assets/.automatic/github/`;

// pull

const pulls: Array<string> =
  await $`typst query resume.typ '<github-pull>' --field value`.json();
const pullData: Record<string, unknown> = {};
for (const pull of pulls) {
  console.log(`Loading PR ${pull}`);
  const {
    number,
    state,
    title,
    updatedAt: updatedAtString,
  } = await $`gh pr view ${pull} --json number,state,title,updatedAt`.json();
  const updatedAt = new Date(updatedAtString);
  pullData[pull] = {
    number,
    state,
    title,
    nameWithOwner: /\/([^/]+\/[^/]+)\/pull\/\d+$/.exec(pull)![1],
    updatedAt: {
      year: updatedAt.getUTCFullYear(),
      month: updatedAt.getUTCMonth() + 1,
      day: updatedAt.getUTCDate(),
    },
  };
}
await $`echo ${JSON.stringify(pullData)} > assets/.automatic/github/pull.json`;

// issue

const issues: Array<string> =
  await $`typst query resume.typ '<github-issue>' --field value`.json();
const issueData: Record<string, unknown> = {};
for (const issue of issues) {
  console.log(`Loading Issue ${issue}`);
  const {
    number,
    state,
    title,
    updatedAt: updatedAtString,
  } = await $`gh issue view ${issue} --json number,state,title,updatedAt`.json();
  const updatedAt = new Date(updatedAtString);
  issueData[issue] = {
    number,
    state,
    title,
    nameWithOwner: /\/([^/]+\/[^/]+)\/issues\/\d+$/.exec(issue)![1],
    updatedAt: {
      year: updatedAt.getUTCFullYear(),
      month: updatedAt.getUTCMonth() + 1,
      day: updatedAt.getUTCDate(),
    },
  };
}
await $`echo ${JSON.stringify(
  issueData
)} > assets/.automatic/github/issue.json`;
