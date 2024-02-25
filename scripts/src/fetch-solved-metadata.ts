#!/usr/bin/env bun
import { $ } from "bun";

await $`mkdir -p assets/.automatic/solved/`;

// stat

const { userCount } = await $`curl https://solved.ac/api/v3/site/stats`.json();

// user

const users: Array<string> =
  await $`typst query resume.typ '<solved-ac-user>' --field value`.json();

const userData: Record<string, unknown> = {};
for (const user of users) {
  console.log(`Loading solved.ac user ${user}`);
  const { tier, rating, arenaTier, arenaRating, rank } =
    await $`curl "https://solved.ac/api/v3/user/show?handle=${user}"`.json();
  userData[user] = {
    solveTier: tier,
    solveRating: rating,
    arenaTier,
    arenaRating,
    rank,
    topPercent: (100 * rank) / userCount,
  };
}
await $`echo ${JSON.stringify(userData)} > assets/.automatic/solved/user.json`;
