#import "components.typ": chip, icon

#let gh-repo(name-with-owner) = link("https://github.com/" + name-with-owner)[
  #icon("devicon/github", bottom: -1em / 6) #text(weight: 700)[#name-with-owner]
]

#let gh-pull-chip-open(content: "Open") = {
  chip(background: color.rgb("#238636"))[
    #set text(size: 8pt, weight: 500, fill: color.rgb("#ffffff"))
    #icon("octicon/git-pull-request-16?color=#ffffff")
    #content
  ]
}

#let gh-pull-chip-merged(content: "Merged") = {
  chip(background: color.rgb("#8250df"))[
    #set text(size: 8pt, weight: 500, fill: color.rgb("#ffffff"))
    #icon("octicon/git-merge-16?color=#ffffff")
    #content
  ]
}

#let gh-pull-req(url) = {
  [#metadata(url) <github-pull>]
}

#let gh-pull(url) = {
  [#metadata(url) <github-pull>]
  let pull-db = json("../assets/.automatic/github/pull.json")
  let pull = pull-db.at(url, default: none)
  if pull == none {
    let match = url.match(regex("https?:\/\/github\.com\/([^/]+)\/([^/]+)\/pull\/[0-9]+")).captures
    return ("nameWithOwner": match.at(0) + "/" + match.at(1), "url": url)
  } else {
    return (..pull, "url": url)
  }
}

#let gh-pull-rich(pull) = {
  if pull.at("state", default: none) == none {
    text(fill: color.rgb("#ff0000"))[\#NO_GITHUB_PULL_DATA\#]
    return
  }
  if pull.state == "OPEN" {
    {
      gh-pull-chip-open()
    }
  } else if pull.state == "MERGED" {
    {
      gh-pull-chip-merged()
    }
  } else {
    pull.state
  }
  link(pull.url)[
    #text(weight: 600)[#pull.title] \
    #text(size: 0.75em)[
      \##pull.number at #datetime(..pull.updatedAt).display()
    ]
  ]
}

#let gh-pull-short(pull, full: false) = {
  if pull.at("state", default: none) == none {
    text(fill: color.rgb("#ff0000"))[\#NO_GITHUB_PULL_DATA\#]
    return
  }

  let match = pull.url.match(regex("https?:\/\/github\.com\/([^/]+)\/([^/]+)\/pull\/[0-9]+")).captures
  let label = if full {
    match.at(0) + "/"
  } else {
    ""
  } + match.at(1) + " #" + str(pull.number)
  link(pull.url)[
    #{
      if pull.state == "OPEN" {
        gh-pull-chip-open(content: label)
      } else if pull.state == "MERGED" {
        gh-pull-chip-merged(content: label)
      } else {
        pull.state
      }
    }
  ]
}

#let gh-issue(url, show-repo: false) = {
  [#metadata(url) <github-issue>]
  let issue-db = json("../assets/.automatic/github/issue.json")
  if issue-db.at(url, default: none) != none {
    let issue = issue-db.at(url)
    if issue.state == "OPEN" {
      {
        chip(background: color.rgb("#1f883d"))[
          #set text(size: 8pt, weight: 500, fill: color.rgb("#ffffff"))
          #icon("octicon/issue-opened-16?color=#ffffff")
          Open
        ]
      }
    } else if issue.state == "CLOSED" {
      {
        chip(background: color.rgb("#8250df"))[
          #set text(size: 8pt, weight: 500, fill: color.rgb("#ffffff"))
          #icon("octicon/issue-closed-16?color=#ffffff")
          Closed
        ]
      }
    } else {
      issue.state
    }
    link(url)[
      #if show-repo {
        issue.nameWithOwner
      }
      #text(weight: 600)[#issue.title] \
      #text(size: 0.75em)[
        \##issue.number at #datetime(..issue.updatedAt).display()
      ]
    ]
  } else {
    text(fill: color.rgb("#ff0000"))[\#NO_GITHUB_ISSUE_DATA\#]
  }
}
