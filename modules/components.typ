#let base-icon(url, size: 1em, width: none, height: none, bottom: -1em / 8) = {
  box[
    #pad(bottom: bottom)[
      #image(
        url,
        format: "svg",
        width: if width == none { size } else { width },
        height: if height == none { size } else { height },
      )
    ]
  ]
}

#let icon(query, size: 1em, width: none, height: none, bottom: -1em / 8) = {
  [#metadata(query) <icon>]
  let icon-db = json("../assets/.automatic/icon/manifest.json")
  if icon-db.at(query, default: none) != none {
    base-icon(
      "../assets/.automatic/icon/" + icon-db.at(query),
      size: size,
      width: width,
      height: height,
      bottom: bottom,
    )
  } else {
    text(fill: color.rgb("#ff0000"))[\#NO\_ICON: "#query"\#]
  }
}

#let icon-solved-ac(size: 1em, bottom: -1em / 4) = {
  base-icon("../assets/brand/solved-ac.svg", size: size, bottom: bottom)
}

#let chip(body, background: color.rgb("#d2d2d2")) = [
  #box[
    #pad(bottom: -3pt)[
      #rect(
        radius: 50%,
        fill: background,
        inset: (left: 5pt, top: 3pt, bottom: 3pt, right: 5pt),
      )[
        #body
      ]
    ]
  ]
]
