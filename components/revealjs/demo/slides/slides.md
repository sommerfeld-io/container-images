# sommerfeldio/revealjs

A Docker image for Reveal.js with PlantUML support.

---

## Sources

[sommerfeldio/revealjs](https://hub.docker.com/r/sommerfeldio/revealjs) on Docker Hub

[Dockerfile source code](https://github.com/sommerfeld-io/container-images/tree/main/components/revealjs) on GitHub

Visit [the projects documentation page](https://sommerfeld-io.github.io/container-images) for a list of all available container images.

---

## Embedded Image

Path must be relative to `index.html`, not `slides.md`.

![Logo](slides/logo.jpg)

---

## Lorem ipsum

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.

---

## PlantUMl with Kroki

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

Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
