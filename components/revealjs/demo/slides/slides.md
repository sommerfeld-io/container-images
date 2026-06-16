# sommerfeldio/revealjs

A Docker image for Reveal.js with PlantUML support.

This is the title slide demonstrating basic text content and the image tag.

---

## Sources

This slide lists external links to the Docker Hub image, the source code, and the project documentation.

[sommerfeldio/revealjs](https://hub.docker.com/r/sommerfeldio/revealjs) on Docker Hub

[Dockerfile source code](https://github.com/sommerfeld-io/container-images/tree/main/components/revealjs) on GitHub

Visit [the projects documentation page](https://sommerfeld-io.github.io/container-images) for a list of all available container images.

---

## Embedded Image

This slide demonstrates how to embed an image — the path must be relative to `index.html`, not `slides.md`.

![Logo](slides/logo.png)

---

## Lorem ipsum

This slide shows a paragraph of placeholder body text to demonstrate text-heavy content layout.

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.

---

## PlantUMl with Kroki

This slide renders a PlantUML mind map diagram via the Kroki server, demonstrating diagram-as-code support.

```language-plantuml
@startmindmap

skinparam monochrome false
skinparam ranksep 25

skinparam backgroundColor transparent
skinparam arrowColor #42AFFA
skinparam lineColor #42AFFA

* Lorem Ipsum

--[#42AFFA] Lorem Ipsum
--- dolor sit amet
--- consectetur adipiscing elit
--- sed do eiusmod tempor incididunt ut labore
---- et dolore magna aliqua

++[#42AFFA] Lorem Ipsum
+++ dolor sit amet
+++ consectetur adipiscing elit
+++ sed do eiusmod tempor incididunt ut labore
++++ et dolore magna aliqua

@endmindmap
```

---

## Duis aute irure

This slide demonstrates a second paragraph of placeholder text to round out the standard text-content examples.

Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

---

<!-- .slide: data-background="slides/wallpaper.jpg" -->

## Full-Screen Background

This slide demonstrates a full-screen background image using the RevealJS `data-background` attribute.

---

## Dummy Slide One

Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium.

---

## Dummy Slide Two

Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur.

---

## Dummy Slide Three

At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum.

---

## Dummy Slide Four

Nam libero tempore cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime.

---

## Dummy Slide Five

Temporibus autem quibusdam et aut officiis debitis rerum necessitatibus saepe eveniet ut et voluptates.
