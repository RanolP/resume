#import "util.typ": *

#let formatDuration(duration) = {
  let duration-in-weeks = if type(duration) == "duration" { duration.weeks() } else { duration }
  let year = calc.floor(duration-in-weeks / 4 / 12)
  let month = calc.rem(calc.floor(duration-in-weeks / 4), 12)
  [
    #if year > 0 { str(year) + "년" }
    #if month != 0 { str(month) + "개월" }
  ]
}

#let activityList(entries, body-header: none, header: none) = {
  let total-duration-in-weeks = 0
  for (from, to, ..) in entries {
    if type(to) != "datetime" { continue }
    total-duration-in-weeks += (to - from).weeks()
  }

  if body-header != none {
    body-header(formatDuration(total-duration-in-weeks))
  }
  locate(
    loc => {
      let header-counter = counter("activity-list-header-counter")
      let header-state-id = header-counter.at(loc).at(0)
      header-counter.step()
      let header-state = state("activity-list-row-header-state-" + str(header-state-id), (:))

      grid(
        columns: (auto, 1fr),
        gutter: 15pt,
        ..(
          entries.map(
            ((from, to, title, body)) => {
              let header-renderred = (w) => if header != none {
                locate(
                  loc => {
                    header-state.update(header-pages => {
                      let page = str(loc.position().page)
                      return (..header-pages, (page): header-pages.at(page, default: 0) + 1)
                    })
                    locate(
                      loc => {
                        let header-pages = header-state.at(loc)
                        let page = str(loc.position().page)
                        if header-pages.at(page, default: 0) <= 2 {
                          style(styles => pad(right: -measure(header, styles).width + w)[#header])
                        }
                      },
                    )
                  },
                )
              }
              let time = (e) => align(center)[
                #block(breakable: false)[
                  #e
                  #text(size: 10pt, weight: 600)[
                    #{ from.display("[year].[month]") }
                    #if type(to) == "datetime" {
                      [
                        \~
                        #if to != datetime.today() {
                          to.display("[year].[month]")
                        } else {
                          "Present"
                        } \
                        #text(size: 8pt)[약 #formatDuration(to - from)
                        ]
                      ]
                    }
                  ]
                ]
              ]
              let row = (style(styles => {
                time(header-renderred(measure(time([]), styles).width))
              }), block(breakable: false)[
                #hide[#header-renderred(0pt)]
                #pad(bottom: -4pt)[
                  #set text(size: 12pt, weight: 700)
                  #set par(leading: 0.5em)
                  #title
                ]
                #set text(size: 10pt)
                #body
              ],)

              return row
            },
          ),
        ).flatten(),
      )
    },
  )
}

#let activityEntry(body, from: "#INVALID#", to: "", title: "#INVALID_TITLE#") = (from, to, title, body)

#let workExpList(entries) = activityList(entries)

#let workExpEntry(
  body,
  from: "#INVALID#",
  to: "",
  role: "#INVALID_ROLE#",
  organization: "#INVALID_COMPANY#",
  homepage: "",
) = activityEntry(body, from: from, to: to, title: grid(
  columns: (1fr, auto),
  belonging(role, organization),
  if homepage != "" {
    show link: set text(fill: color.rgb("#1c7ed6"))
    show link: underline
    homepage
  },
))
