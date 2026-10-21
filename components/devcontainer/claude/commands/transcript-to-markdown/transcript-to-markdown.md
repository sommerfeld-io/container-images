---
argument-hint: <path-to-transcript-file>
---

# Transcript To Markdown

Turn a text-based transcript (meeting recording transcript, notes, chat log, ...) into either Meeting Minutes or an Architecture Decision Record (ADR), written as a new Markdown file next to the input file.

## 1. Resolve the input file

`$ARGUMENTS` must contain the path to the input file.

- If `$ARGUMENTS` is empty, stop immediately and tell the user: `Usage: /transcript-to-markdown <path-to-transcript-file>`.
- If the file does not exist or is not readable, stop immediately and report that exact problem. Do not guess at a different path.

Read the full content of the input file — this is the transcript you will summarize.

## 2. Ask the user two questions

Before generating anything, ask the user (wait for both answers before proceeding):

1. **Output type**: "Meeting Minutes" or "ADR" (Architecture Decision Record)?
2. **Language**: "German" or "English"?

Do not guess these from the transcript content — always ask.

## 3. Pick the matching template

Templates live in this same directory (next to this command file). Pick exactly one:

| Output type     | Language | Template file                    |
|-----------------|----------|----------------------------------|
| Meeting Minutes | English  | `template-meeting-minutes.md`    |
| Meeting Minutes | German   | `template-meeting-minutes-de.md` |
| ADR             | English  | `template-adr-en.md`             |
| ADR             | German   | `template-adr-de.md`             |

Read the chosen template to see its exact section structure and headings — reuse that structure verbatim (same headings, same table columns, same order). Do not invent additional sections and do not drop sections, even if the transcript has nothing for one of them (write "None" / "Keine" or a short "not discussed" note instead of omitting the section).

## 4. Fill the template from the transcript

Replace every placeholder (`<...>`) with content derived from the transcript. Guidance per output type:

### Meeting Minutes

- **Topic**: one short paragraph on what the meeting/transcript was about.
- **Decisions**: concrete decisions that were actually made — not proposals that were only discussed.
- **Action Items**: one row per action item, with an owner and a due date if the transcript states or implies one. If no owner or date is mentioned, write "unclear" / "unklar" rather than inventing one.
- **Open Questions**: unresolved questions, things explicitly deferred, or follow-ups mentioned "we'll discuss this later".
- Attendees and date: use what's stated in the transcript; if the transcript doesn't state them, write "unclear" / "unklar".

### ADR

- **Title**: a short, specific decision title (not "Meeting about infrastructure").
- **Status table**: `Status` is normally "Proposed"/"Vorgeschlagen" unless the transcript states the decision was already accepted/rejected. `Decision Date` is the date of the transcript/meeting if known, otherwise "unclear"/"unklar". `Outcome` is a one-sentence summary of what was decided.
- **Context**: why this decision was needed — the problem and constraints discussed.
- **Options**: one `### Option X - <Name>` subsection per option that was actually discussed in the transcript, each with *Pros* and *Cons* bullet lists pulled from the discussion. Do not invent options that weren't mentioned.
- **Recommendation**: only include if the transcript contains an actual recommendation distinct from the final decision; otherwise omit this section.
- **Decision**: the decision that was actually made, in the bold-sentence style the template shows, followed by concrete implementation details if any were discussed. Leave the optional `> [!IMPORTANT]` superseding-decision callout out entirely unless the user explicitly says this ADR revises an earlier one.
- **Consequences**: concrete follow-up implications/work items mentioned in the transcript.
- **Author**: use the name(s) mentioned in the transcript if any; otherwise write "unclear" / "unklar". Always note that the document was generated from a transcript with AI assistance, and that the decision itself lies with the human participants, not the AI.

Write in the language chosen in step 2 throughout — headings, table labels and body text all come from the matching template, so this should already be consistent as long as you used the right template file.

## 5. Write the output file

Write the result next to the input file, in the same directory, using this naming convention:

- `<input-file-basename>-minutes.md` for Meeting Minutes
- `<input-file-basename>-adr.md` for an ADR

`<input-file-basename>` is the input file's name without its extension (e.g. `standup-2026-04-29.txt` → `standup-2026-04-29-adr.md`).

If a file with that name already exists, ask the user whether to overwrite it before writing.

## 6. Report the result

End your response with the path to the generated file, e.g.:

```plain
Generated: <path-to-output-file>
```
