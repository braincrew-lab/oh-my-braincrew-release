# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - 2026-11-08

### Added
- drift-code, a rule change only the code carries
- retention cadence (memory status nudge, omb-clean after teardown), reclaimable meter, docs
- omb retention plan|apply|status with index-confirmed, bounded-log deletion
- age-based run compaction and bounded journals extending logs-purge
- PostToolUse recall hook counts Read/Grep of memory topic files; wrapper fast path skips the binary for other reads
- wiki health from omb wiki status (live stale count, max page vs 40 KiB ceiling, contract-page verbatim excerpts) and ceilings for max page size and dangling links
- dreaming proposes wiki-refresh candidates (refresh verdict, proposal only) and matches wiki and memory by code terms across languages
- omb wiki status reports live Claim health apart from publication; omb wiki stale-sources lists pages whose cited sources changed since their evidence commit; memory status warns wiki_stale
- injected chunk view with per-chunk recall signal; SessionStart memory block vs budget, core vs index lines, promote/demote counts
- dream-candidates proposes promote/demote layer moves and wiki <-> memory boundary moves from recall, verified freshness, hypothesis state and drift
- 4 KB injected memory budget; root index lists every stable topic with when it applies; overflow moves core items to index lines
- transcript dream input for notes contradicted by later prompts; index origin-less claude -p prompts (schema 3)
- --dream-after runs a budgeted /omb:memory update turn in the memory arm, counted in its cost
- omb:memory update dreaming pass with read-only verifiers, proposal and approval
- deterministic dreaming candidates, recall counter, dream state and status nudge
- transcript index metrics and layer ceilings
- bounded read-only transcript index with evidence-id lookup, retrieval source and teardown indexing
- learning dispositions after verified post-PR fixes, hypotheses on unresolved runs
- dated unverified hypothesis topics, labeled in search and metered apart
- honest recall columns and a drift sequence
- report legacy stores, memory-field agents and topic evidence
- initialize the tracked .omb-memory store and retire legacy role memory
- add CL-Bench-style memory vs stateless eval harness
- add deterministic memory footprint meter
- add --detect-only mode and pinned detection eval harness
- diff-mapped lenses, independent verification, tiered models

### Fixed
- swallow killpg EPERM only for an exited leader; size the apply test budget
- pyright 0 on darwin for the #433 tests and pipe salvage typing
- keep a gh child's zombie-group EPERM out of cleanup
- settle a child that exits before its identity on Darwin
- mark vanished sources missing before cap eviction; probe every omb the wrapper may run
- init refuses a store over the OMB 1.7 caps before writing
- honor OMB_HOOK_OMB only as an absolute path
- R7 review P3s for dreaming and the transcript backfill
- steer hooks with OMB_HOOK_OMB instead of a per-task HOME
- run the product's hooks on this checkout's omb and refuse build skew
- keep on-disk indexes byte-identical to OMB 1.7, render the R8 root index at read time
- fail closed on unreadable inputs, digest-confirm sources, private log
- cap eviction keeps missing sources longest
- stub journals only for schedulers that advertise journal_stubs
- checkpoint only between JSONL records, yield to a concurrent refresh at a checkpoint, never chmod a custom index directory
- batch cron compaction per job, bound journals by settled runs, flush the log per class
- refuse non-regular, foreign or hard-linked index sidecars; hermetic git in teardown tests; lock the fake CLI turn counter
- type the root index header as str lines (pyright)
- excerpt check needs word boundaries and a clause end, reports unparsed anchors and stays inside the repository
- code-term overlap keeps code spans whole, needs real identifiers and ignores terms most wiki sections share; pyright-clean dream.py
- reworded-Claim attribution drops stopwords, needs 3 content words and fails closed when the other scope covers 25%
- pyright narrowing, exhaust incremental_vacuum so the file cap holds, re-mask older indexes before read-only search/find
- recall hook counts only the active checkout's layers; Read|Grep hook timeout 10 s, guarded by a fail-open-only registry check
- a legacy core larger than the layer share is injected with a context_budget warning, not dropped as stale_index (the generator's last index level is valid)
- memory block measured as the budget counts it, unlinked collapsed index lines and migration warnings as chunks, recall and wiki notes
- demote core items by length in characters, never for low recall; rule marks read the wiki heading; notes for thin recall coverage and cross-language wiki overlap with the best cover
- reads never drop an older store (indexes regenerated in memory, legacy core injected with a warning), init migrates, caps hold when an update writes the core; layer room shared with the workspace and path-independent; clipped index lines and a fold-all level
- attribute a reworded Claim to the heading section holding its words, so mixed-history pages stop excluding 124 current Claims as unresolved_historical_scope
- dream evidence ignores replies and the last dream's sessions; missing and renamed cites; commit-time topic age; verifier reads are not recalls
- freeze schema 3 backfill offsets at migration, skip evicted sources, count backfilled rows, ignore command wrappers
- private index dir without the ancestor rule, in-place migration and re-masking, raw-text ranking, shared cwd rule for isolation worktrees and cron
- linear line-anchored .netrc rule; mask only header-shaped auth and name=value cookie values
- safe-open sources, cwd-verified sessions, whole-text redaction, private WAL index, bounded teardown and fenced history evidence
- mask credential headers, lowercase bearer and .netrc passwords; move strip_untrusted_markers to hook.core
- never clip an actionable plan or todo path; show it relative or withhold it
- require a scored predecessor for memory-arm reruns and archive downstream attempts when a cascade stops
- guard post-PR memory saves and keep RED evidence durable
- hypothesis age is a status/check warning, not a CI gate
- read the worktree DB from a temp-dir snapshot so WAL sidecars never appear in the measured checkout
- keep scanning after memory apply, detect cp/mv/touch/dd and list unhandled writes
- gate reload on .omb-memory and the injected block, keep the AGENTS block to pointer plus mechanics
- keep the memory routing section at three lines so fixture counts hold
- count archived attempts and pings in run spend and keep the meter from writing bytecode into the measured checkout
- look up product code only inside recorded checks and count SessionStart output only when the OMB hook is registered
- correct review topics flagged in the R3 review
- look up recurrence keys with the exact memory search
- stop a memory-arm unit after a runner error, require --cascade for downstream reruns and index later-task metrics by sequence position
- keep foreign scratch trees, fail on grader errors, kill the whole group and exclude runner errors from scores
- pin a copy of the claude CLI per run, abort on launch failures and rerun single tasks with --only
- count per/Apply reads, add default-path required reads, hermetic mode
- restore sibling exclusions in descriptions and route hints to Skill()
- import AGENTS.md from the OMB-owned part of CLAUDE.md
- restore the English sub-agent report rule and widen resident triggers
- write commit bodies in English per the language owner
- accept one-line paths lists and resident rules in rules-fm-check
- bound SessionStart worktree recovery to the current checkout
- treat quota and API failures as infrastructure errors, abort the run and ping before it
- follow the goal read graph to closure and model host loading
- isolate arms, exclude user settings, move host transcripts and kill timed-out process groups
- grade rounding only under a passing rate reading and check __all__ and migration registration
- exclude dev-only skill evals from the duplication scan
- resolve an unmerged ticket's P0 evidence through cand_ids and ignore malformed usage events
- audit the ticket's own contract promotion beside its merged records
- decode C-quoted git paths before statting ignored files
- name the phase at every spawn instruction and close round-3 review follow-ups
- name P0 evidence per record and relabel the h3-r3 hook truth P0
- skip rule and semantic checks on shape-invalid blocks
- keep VERIFY's contract answer through RANK and audit unevidenced promotions
- audit only shape-valid blocks so malformed axes never abort scoring
- treat non-string audit links as unlinked instead of crashing
- address round-2 review on field refusals, ticket contracts and eval doc size
- tie completion evidence to the write boundary and report preservation apart
- keep FIND's original axes beside the realism normalization; report incomplete evidence apart
- establish contract validity before realism and severity
- classify egress sinks by their consumers before producer plausibility
- reconcile precondition fields to IDs and audit per-field refusal attempts
- count missing realism evidence on unrealistic triggers as a rule violation
- exclude host runtime artifacts from the ignored check; report realism mismatches as rule violations
- address review of round-1 rules and harness
- rank a missing test alone as P3
- require producer and contract evidence for trigger realism
- verify contract obligations per path, not per group
- keep read-only review roles from writing agent memory or runtime files
- require one merged record per ticket cand_id
- refuse drafts in all s4 family gates; GT-s1-1 is P2
- address review of severity axes and contract coverage
- make controls c1 and c4 clean and pair them by one axis
- cover large diffs by contract obligations, not file count
- record severity axes and derive priority from harm, realism, and guard
- schema-3 FIND misses stay in the denominator; rescore labels in their own mapping
- treat all text blocks of one assistant message as one output
- one rescore row per harness digest; tolerate non-UTF-8 transcripts
- unterminated replacement blocks and unavailable rescore rows
- reject non-string discarded ids as shape errors
- undrained bundles, unknown raw outcomes, honest summary keys
- show finding consequence to the judge for adjudicated truths
- same-turn completion bundle, stage-separated recall, attempt links
- clean unreadable reviewer dirs without losing rep metadata
- remove read-only reviewer leftovers when cleaning a rep
- bound gate-reader tracing and name both escalation sources
- treat gate inputs as risk hunks and escalate depth before FIND
- select depth by hunk behavior, not path
- address Phase A review on reach, L7 fields and eval pairs
- derive privileged-action preconditions and define realistic severity
- make the s3/c3 pair single-variable and tidy detect-only records
- gate the severity floor on cited reach and tighten controls
- derive priority from consequence and repair eval controls
- portable tmp guard test, HEAD/ref mutation check, malformed block safety
- keep reviewer failures in the denominator and lock the scratch tree
- isolate experiment roots and tighten eval scoring
- refuse legacy worktree watch state, reconcile answers by newest touching reply
- needs-human transitions, authoritative watch root, retired-grant floor
- host-authorized merge, canonical merge state, needs-human never handled
- refresh wiki evidence and format contract tests
- strengthen evidence gates and review routing
- missing-field check in L1a, new-exposure counts as introduced
- severity floor, external-behavior proof, L5 egress pass, convergence guard
- re-dispatch unreproduced candidates in trace-only mode
- agent input adapters, final Herdr gate, fork Herdr route, code-debug trace-only mode

### Improved
- replace the .omb/archive stopgap with bounded transcript search
- steer memory by purpose with one owner and recall where decisions happen
- drop the memory frontmatter field and retire agent-memory plumbing
- replace restated owner text on the goal path with pointers
- hide Skill("omb") wrapper commands from the model catalog
- one owner per repeated block, short omb-tdd core, explicit conditional reads
- shrink the resident layer to triggers and split the rule index
- state each record once in returns and reports and check the drain before printing
- bound repeated attempts and rebuilt setup without dropping any obligation
- cut preparation, duplicated context and report cost without dropping detections
- cluster only same-fix candidates and checkpoint lens budgets

### Documentation
- reconcile Claims shifted by the EPERM narrowing
- refresh the transport-redaction cite shifted by the EPERM narrowing
- reconcile Claims shifted by the #433 worker fix
- record the #433 flake fixes
- correct timeouts topic budgets and refresh shifted cites
- reconcile Claims shifted by the merge-gate fix
- reconcile Claims after merging main (R1-R9); restore the R10 retention, init-cap and absolute OMB_HOOK_OMB statements
- init refuses stores over the 1.7 caps; OMB_HOOK_OMB only as an absolute path
- reconcile Claims shifted by the transcript fixes from main
- reconcile Claims shifted by the R7 review P3s
- reconcile Claims after merging main (R7)
- reconcile Claims after merging R9 with the OMB_HOOK_OMB wrapper override; keep the retention command map entry
- reconcile Claims for the OMB_HOOK_OMB hook wrapper override after merging R8
- reconcile Claims for the OMB_HOOK_OMB hook wrapper override
- reconcile Claims after merging main (R6)
- reconcile Claims after merging R9 with the 1.7-compatible memory indexes; keep the retention command map entry
- reconcile Claims after merging the 1.7-compatible on-disk memory indexes
- reconcile Claims for the 1.7-compatible on-disk memory indexes
- reconcile Claims shifted by the R10 review fixes
- re-anchor transcript Claims after the checkpoint fixes
- retention in the command map; reconcile Claims shifted by R10
- re-anchor transcript Claims after the sidecar check
- move standalone delegation into the Herdr page, history description, full-clause ticket-schema excerpt, reconcile Claims after the R8 merge
- reconcile Claims after merging the R7 pyright fixes
- reconcile Claims after merging the R6 pyright fixes
- excerpt guidance limited to wording a decision depends on; CHANGELOG counts measured (147 -> 21, 126 recovered)
- re-anchor transcript Claims after the pyright and vacuum fixes
- reconcile Claims after the R8 re-review fixes
- split the 83 KB development page into goal pipeline, verification, Herdr delegation, knowledge handoff and history pages; verbatim contract excerpts; reconcile Claims after R9
- reconcile Claims after the R8 review fixes
- record the R8 review fixes; wiki overlap note wording
- record R9 wiki health, stale-sources, wiki-refresh dreaming and verbatim-excerpt guidance; test the wiki page ceiling and contract excerpts
- omb-wiki and omb-doc require verbatim excerpts for contracts, identifiers, limits and ordering; one responsibility per page under 40 KiB; wiki orients, source confirms
- reconcile Claims after the R8 memory layer budget and promotion/demotion
- record the R8 memory layer budget, promotion/demotion candidates and meter chunk view
- reconcile Claims after the R7 review fixes
- record the R7 review fixes
- reconcile Claims after merging the R6 fixes into R7 dreaming
- reconcile Claims after the R7 dreaming pass
- document the dreaming pass, its CLI and the eval option
- reconcile Claims after the transcript re-review fixes
- record the transcript re-review fixes
- reconcile Claims after the R6 transcript security fixes
- teardown indexing is best effort; transcript evidence is fenced untrusted history
- reconcile Claims after the R6 transcript layer
- record the R6 transcript layer
- reconcile Claims after the R5 review fixes
- correct the R5 hypothesis and learning-disposition entries
- reconcile Claims after the R5 learning loop and hypothesis topics
- record the R5 learning loop and hypothesis topics
- refresh Claims metadata after the R4 review fixes
- soften recall-before-act and record the R4 review fixes
- reconcile Claims after the R4 memory steering changes
- record the memory eval recall columns and drift sequence
- reconcile Claims after the R3 review fixes
- reconcile Claims after the memory R3 note-store changes
- key feedback recurrence on operational memory and record single-incident rule evidence
- reconcile Claims after the review follow-ups
- reconcile Claims after the injected-layer diet
- make AGENTS.md the single shared owner and fix commit language
- describe the memory meter and eval review fixes
- note the memory meter and memory eval harness
- refresh evidence after removing review-agent memory
- note unterminated-block and unavailable-row eval fixes
- refresh pr-watch root evidence after legacy-state refusal
- refresh pr-watch merge authority, state root and needs-human evidence

### Maintenance
- Merge pull request #441 from braincrew-lab/fix/ci-flaky-and-memory-followups
- force the zombie-leader state with ps instead of os.waitid
- give the cross-process apply a budget sized to its work
- record only tab-close retry backoff, not subprocess polls
- Merge pull request #440 from braincrew-lab/feat/memory-r10-retention
- unit-test the wiki-boundary common-code-term cut
- registry budget takes its fail-open exemptions from FAIL_OPEN_GROUPS
- keep both transcript-index test additions; take main's fake-CLI counter comment and openwiki for reconcile
- Merge pull request #439 from braincrew-lab/feat/memory-r9-wiki
- transcript and registry-budget test fixes; openwiki taken from R9 for reconcile
- Merge pull request #438 from braincrew-lab/feat/memory-r8-layers
- exclude the fail-open Read|Grep recall group from the event-deadline minimum
- lock the fake CLI's shared turn counter and log under --parallel
- Merge remote-tracking branch 'origin/main' into feat/memory-r8-layers
- Merge pull request #437 from braincrew-lab/feat/memory-r7-dreaming
- OMB_HOOK_OMB wrapper override, eval keeps real HOME; openwiki taken from R9 for reconcile
- OMB_HOOK_OMB wrapper override, eval keeps real HOME; openwiki taken from R9 for reconcile
- Merge remote-tracking branch 'origin/main' into feat/memory-r7-dreaming
- Merge pull request #436 from braincrew-lab/feat/memory-r6-transcripts
- 1.7-compatible on-disk memory indexes; openwiki taken from R9 for reconcile
- 1.7-compatible on-disk memory indexes; openwiki taken from R9 for reconcile
- dream keeps R9 typed source narrowing with R8 readable-index guard; openwiki taken from R9 for reconcile
- Merge branch 'feat/memory-r7-dreaming' into feat/memory-r8-layers
- wiki boundary keeps R8 stats and heading-or-text rule marks with R9 code-term overlap and wiki-refresh
- Merge branch 'feat/memory-r6-transcripts' into feat/memory-r7-dreaming
- Merge remote-tracking branch 'origin/main' into feat/memory-r6-transcripts
- Merge pull request #435 from braincrew-lab/feat/memory-r5-learning
- Merge remote-tracking branch 'origin/main' into feat/memory-r5-learning
- Merge pull request #434 from braincrew-lab/feat/memory-r4-steering
- Merge remote-tracking branch 'origin/main' into feat/memory-r4-steering
- Merge pull request #432 from braincrew-lab/feat/memory-r3-notes
- Merge branch 'feat/memory-r6-transcripts' into feat/memory-r7-dreaming
- Merge remote-tracking branch 'origin/main' into feat/memory-r3-notes
- Merge pull request #431 from braincrew-lab/feat/memory-r2-injected
- Merge remote-tracking branch 'origin/main' into feat/memory-r2-injected
- Merge pull request #430 from braincrew-lab/feat/memory-r1-measurement
- Merge branch 'feat/memory-r1-measurement' into feat/memory-r5-learning
- drop core lines the purpose rule now owns
- re-baseline injected budgets on the corrected meter
- cap session-start project-owned and goal standard-path load
- Merge pull request #429 from braincrew-lab/fix/ultra-review-round3
- Merge remote-tracking branch 'origin/main' into fix/ultra-review-round3
- Merge pull request #428 from braincrew-lab/fix/ultra-review-round2
- record per-phase usage from host events and keep phase USD unknown
- report raw, real-defect and non-defect control counts apart; repair round-2 control defects in new pairs
- format field ledger test
- add round-2 control revisions that fix the adjudicated real defects in both pair members
- Merge pull request #427 from braincrew-lab/fix/ultra-review-round1
- harden revised fixture pairs from review
- make the h3/ch3 r2 pre-push check configurable with a passing default
- add repaired control fixture revisions and an adjudication overlay
- Merge pull request #426 from braincrew-lab/fix/ultra-review-severity-axes-contracts
- add sealed holdout cases h1-h6/ch1/ch3/ch5 after freezing rules; limit merged fix scope by origin
- Merge pull request #425 from braincrew-lab/fix/ultra-review-measurement-integrity
- apply independent ground-truth adjudication
- Merge pull request #424 from braincrew-lab/fix/ultra-review-depth-by-behavior
- Merge pull request #423 from braincrew-lab/fix/ultra-review-severity-calibration
- Merge pull request #422 from braincrew-lab/feat/ultra-review-eval-harness
- Merge pull request #421 from braincrew-lab/fix/merge-gate-authority
- Merge pull request #420 from braincrew-lab/chore/harness-assessment-improvements
- remove obsolete verifier wording assertion
- Merge pull request #419 from braincrew-lab/feat/ultra-review-lenses
- sort ultra-review contract imports
- Merge pull request #418 from braincrew-lab/feat/release-auto-approve



## [1.7.0] - 2026-11-05

### Fixed
- run the pr-watch bundle smoke only on POSIX release builds
- bind PowerShell checksum mock parameters by name
- fail closed on release lookup errors, lock build backend, paginate latest check
- harden publish gate, client trust and CI hygiene
- narrow optional push result in pr-watch journal test
- address ultra-review findings on merge gate and pipeline ending
- realign openwiki claims to moved herdr evidence
- converge verify rows and pin codex reasoning effort
- require explicit review clearance
- stay in kept worktrees and reconcile stale records; refresh wiki claims
- align remaining EP and P{N} wording with callers and docs
- unify terminology and emphasis in workflow skills
- merge the verified base ref, not origin/<base>
- clear residual rubric findings after re-partition
- repair defects introduced in cycle 3
- state that the flaky rerun delays the no-progress budget
- address ultra-review findings and add live goal checkpoint checks
- bound verifier reports and restore domain-reviewer placeholder
- close rubric gaps in waits, spawn bounds and output contracts

### Improved
- install OMB only from public releases
- remove omb-qafix; keep worktrees after PR; clean merged PRs from conversation
- resolve cycle 2 rubric findings (cycle 3)
- resolve cycle 1 rubric findings (cycle 2)
- re-partition agents and sharpen skill prompts (cycle 1)

### Documentation
- describe 1.7.0 changes and upgrade notes
- refresh release checksum, downgrade and token scope evidence
- describe public-release-only install and retired source channel
- refresh pr-watch merge grant, draft gate and stale evidence
- document post-PR ultra-review, allow-merge gate and Copilot handling
- document conditional agent skill loading and refresh wiki
- refresh OpenWiki claims after harness re-partition
- record goal pipeline hardening under Unreleased
- align docs and wiki with goal hardening behavior

### Maintenance
- Merge pull request #417 from braincrew-lab/docs/readme-1-7-0
- Merge pull request #415 from braincrew-lab/fix/release-pipeline-hardening
- Merge pull request #414 from braincrew-lab/refactor/public-release-install-only
- Merge pull request #413 from braincrew-lab/fix/post-review-followups
- checkpoint before Herdr Verify
- Merge pull request #412 from braincrew-lab/feat/post-pr-review-merge-pipeline
- checkpoint before Herdr Verify
- checkpoint before Herdr Verify
- checkpoint before Herdr Verify
- Merge remote-tracking branch 'origin/main' into feat/post-pr-review-merge-pipeline
- Merge pull request #411 from braincrew-lab/fix/herdr-verify-convergence
- checkpoint before Herdr Verify
- checkpoint before Herdr Verify
- Merge pull request #410 from braincrew-lab/refactor/agent-skill-conditional-loading
- checkpoint before Herdr Verify
- checkpoint before Herdr Verify
- checkpoint before Herdr Verify
- Merge pull request #409 from braincrew-lab/fix/clean-from-conversation
- Merge pull request #408 from braincrew-lab/fix/agents-skills-p2-wording
- Merge pull request #407 from braincrew-lab/fix/agents-skills-residuals
- Merge pull request #406 from braincrew-lab/refactor/agents-skills-optimization
- format changed contract tests
- Merge pull request #404 from braincrew-lab/feat/goal-prompt-hardening



## [1.6.0] - 2026-11-01

### Added
- retire listed harness paths

### Fixed
- align update output references with the item-level summary
- keep harness item keys posix and lock in flag pass-through
- name changed items and harness source in update output
- replace legacy omb agent entries outside the managed block
- satisfy repository-wide pyright in retirement tests
- align main's new tests and docs with the retirement result
- stop omb-run on a plan row naming a missing skill
- deliver the security owner to the cronjob entry
- show the Depends case of the Prohibited rule in api-implement
- name domain exceptions in the owner rule line
- deliver pr-body owner to git-commit in PR mode
- restore the one-caller bullet in coding principles
- pin git locale and environment in retirement
- bind seed import before handling its error
- keep injected text out of reports
- restore wiki modes in the omb router

### Improved
- finish naming, pattern and git owner cuts
- state role boundaries in implement roles
- merge infra and mermaid roles and retire unused skill
- trim implement roles to their own duties
- move omb-plan prompts to rules
- move omb-run branch detail to references
- move pr-watch recovery detail to references
- trim core roles
- trim harness and security roles
- trim ui and infra roles
- trim backend roles
- merge explorers
- merge domain orchestration
- compress doc templates
- trim explain examples
- trim setup reference
- trim tdd teaching
- trim generic rubric items
- merge ci generators
- remove lsp aliases
- merge prompt skills
- trim langchain references
- shrink mermaid skill
- replace react catalogs with criteria
- define resident core
- merge worktree and hook owners
- record taste-based recommendations
- move tool rules to owners
- merge security owner
- merge infra owners
- merge ai owners
- merge ui owners
- move streaming rules to skill
- merge db owners
- merge api rules into owners
- consolidate naming owners
- deliver owners in role bodies
- set one precedence owner
- own fix plan layout in omb-fix
- move git and delivery rules to owners
- replace generic workflow rules
- define content labels

### Documentation
- realign codex compat claims and restore the legacy agent behavior
- refresh evidence for shifted update-output claims
- realign update output claims after review fixes
- describe item-level update output and harness source line
- realign codex compat claims after legacy agent fix
- realign claims after harness lightening
- refresh docs left stale by the lightening
- describe design-patterns after the catalog cut
- add breaking migration notes
- move rationale out of resident rules
- add first-stop decision table

### Maintenance
- Merge pull request #402 from braincrew-lab/fix/codex-config-legacy-agents
- take main into fix/codex-config-legacy-agents
- Merge pull request #403 from braincrew-lab/fix/update-output-clarity
- Merge pull request #401 from braincrew-lab/refactor/taste-first-harness-lightening
- Merge branch 'main' into refactor/taste-first-harness-lightening
- split oversize pr-watch and ultra-review contracts
- split oversize rule and seed contract files
- lock delivery and retirement checks
- Merge remote-tracking branch 'origin/main' into refactor/taste-first-harness-lightening



## [1.5.0] - 2026-10-31

### Added
- require plain one-at-a-time questions without metaphors

### Fixed
- address ultra-review findings on update output
- reject symlinked marker directory during cleanup
- close layered verification leaks in the fix loop
- extend PR diagram quoting to erDiagram labels
- close ultra-review gaps in budget and integrity checks
- repeat cross-review after a candidate-changing re-run and route reproduction tests by runner
- keep veto reviewers and refactoring depth under planning levels
- realign omb-interview OpenWiki claims after rule insertion
- keep review requests out of write-capable task mode

### Documentation
- realign installation claims after update output fixes
- document update lock and skip conditions
- record update lock and symlink hardening
- realign goal VERIFY cross-review Claims after review fix
- document omb-verify levels and goal VERIFY high
- document planning levels for plan, plan-review and goal

### Maintenance
- Merge pull request #400 from braincrew-lab/feat/omb-update-output-ux
- checkpoint before Herdr Verify
- checkpoint before Herdr Verify
- checkpoint before Herdr Verify
- checkpoint before Herdr Verify
- Merge pull request #398 from braincrew-lab/feat/omb-verify-levels
- give the PowerShell contract test a cold-start budget
- Merge pull request #399 from braincrew-lab/feat/pr-body-visual-explanation
- checkpoint before Herdr Verify
- pin medium+ requirement row grading
- checkpoint before Herdr Verify
- checkpoint before Herdr Verify
- Merge pull request #397 from braincrew-lab/feat/plan-review-levels
- Merge remote-tracking branch 'refs/remotes/omb-base/3159399f2a7e728bd18ade4a32702025df5fb1ff6f44ce2624f029a7e50e8c83/main' into feat/plan-review-levels
- checkpoint before Herdr Verify
- Merge pull request #395 from braincrew-lab/refactor/consolidate-codex-skill
- Merge pull request #396 from braincrew-lab/feat/interview-plain-single-question



## [1.4.5] - 2026-10-29

### Fixed
- read answer ownership from viewerDidAuthor
- keep goal autonomous and make GitHub the only answer record
- recover a pr-watch reply posted before its lease was lost
- clear gh_failures when a pr-watch run ends resumably
- refuse pr-watch state writes from a session without the lease
- retry the supervisor claim read that races the publish
- apply an explicit update --apply-from archive as given
- satisfy pyright in pr-watch and cronjob evidence tests

### Improved
- retire ultra-goal and Electron harness surfaces
- simplify goal pipeline and add codex-exec wrapper

### Documentation
- describe the GitHub answer record and realign evidence
- check wiki evidence before each pr-watch push
- describe the pr-watch state-write lease check
- realign standalone launch test evidence
- realign update.py evidence after the apply-from fix
- cite D-033 body line instead of blank line
- add SPEC-001 and the simplification roadmap
- update docs and openwiki for the simplified goal harness
- record 2026-10-27-simplify-goal-doc-harness interview
- describe ultra-goal merge waits in place of release summary

### Maintenance
- Merge pull request #394 from braincrew-lab/refactor/simplify-goal-doc-harness
- cover reply thread repository and comment paging
- add TLA+ sanity, deadlock and three-session checks
- mirror the resumable-end state write in both models
- prove the pr-watch lease properties in Lean for any session count
- add the pr-watch lease TLA+ model and a drift guard
- add fake-run QC suite and qc-smoke script
- Merge pull request #393 from braincrew-lab/docs/readme-latest-release



## [1.4.4] - 2026-10-27

### Fixed
- skip ultra-goal relaunch while the goal session is mid-turn
- re-anchor stop inventory and tolerate dangling bin links

### Documentation
- re-anchor merge-wait claims after relaunch fix
- refresh publication metadata after CI fix
- document merge waits, notices and merge-check stability
- publish ultra-goal merge waits and merge-check stability

### Maintenance
- Merge pull request #392 from braincrew-lab/fix/goal-merge-stability-and-waits
- checkpoint before Herdr Verify



## [1.4.2] - 2026-10-22

### Fixed
- require a precedent row for every changed endpoint
- add auth to api precedent table and pair veto test domains

### Documentation
- publish api and db plan design gates

### Maintenance
- Merge pull request #391 from braincrew-lab/docs/openwiki-api-db-plan-gates
- Merge pull request #388 from braincrew-lab/feat/api-db-naming-plan-gates
- checkpoint before Herdr Verify



## [1.4.1] - 2026-10-20

### Fixed
- accept herdr 0.9.5 or newer

### Improved
- make version gate public and refuse pre-releases

### Documentation
- re-anchor installer stop rows after the version gate change

### Maintenance
- Merge pull request #387 from braincrew-lab/fix/herdr-min-version
- Merge pull request #386 from braincrew-lab/fix/release-smoke-legacy-preserve



## [1.4.0] - 2026-10-20

### Added
- add scheduler self-healing and supervision coordinator
- add goal merge completion and watch detection
- add goal-run record and workflow session foundation
- add autonomy workflow contracts

### Fixed
- expect preserved legacy codex copies in release smoke test
- make the destructive-migration check a keyword tripwire
- catch owned, extension and multi-line column drops
- flag database drops and bound ultra-goal event files
- hash the reply as GitHub stored it in the failed-read fallback
- keep a conservative fingerprint when the post-reply read fails
- fingerprint threads against the pre-call state
- adopt only own marked comments, pin effect fingerprints
- journal marked comments and bound body reads
- keep the watch's own resolution out of fresh evidence
- close four review gaps in roadmap and watch evidence
- post each outbox payload from its own file
- read the boot id before the darwin start probe
- refuse state writes that predate a stop or handover
- run begin as one lease-guarded section
- decide every end mutation under the lease guard
- leave a lease alone when end saw no state directory
- hold the lease guard across creation, end and rollback
- guard pr-watch lease release and refuse a changed job_id
- delete the merged branch by compare-and-swap on GitHub
- delete only when origin pushes to the recorded repository
- delete the merged branch only under a ref lease
- resume goal runs on fresh evidence of ended watch
- clear the stale session binding when resume takes over
- verify checkout identity on adoption; watch new evidence
- require the run's git common dir in checkout-preflight
- bind preflight path, keep budget marker, gate effects
- validate adoption ownership and fresh review evidence
- judge only complete migration patches, cap progress resets
- hash preserved files in chunks and re-anchor stop inventory
- keep force-tracked ignored deletions out of seeding
- bound report reads, restart empty panes, cap lookup
- launch added-repository runs in their own checkout
- fingerprint watch evidence and bound its read budget
- resume an ended standalone watch on fresh PR evidence
- keep a present agent with unknown status alive
- keep finished turns alive and pin re-resolution flow
- close verify findings on merge, diagnosis and effect gate
- classify protected-folder warning anchors (bundle 5)
- make prune stat test independent of pathlib internals (bundle 3)
- re-anchor stop inventory rows moved by the review fixes
- warn on root-anchored gitignore rules that hide negations
- pin checkout identity and base across prepare
- decode evidence paths throughout retrieval
- decode evidence paths and accept large recovery grants
- pin the prepared base on every route and tolerate a stale fetch refspec
- recheck excludes against the origin base and fetch the default branch
- settle checkout failures on origin base and backfill excludes on every route
- accept base in the worktree-add test stub
- read the live origin default and recheck before ff
- re-append negations listed before their positive rule
- keep exclude negations effective and repeat stash restore warnings
- align CI fixtures with checkpoint safeguards

### Improved
- remove duplicate reviews and regenerate compat

### Documentation
- republish pages for the migration tripwire and bounded event read
- document the destructive-migration tripwire limits
- republish pages for the failed-read reply fingerprint
- republish pages after roadmap and watch evidence fixes
- republish pages after outbox payload fix
- republish pages after state-generation and observe fixes
- republish pages after lease guard and roadmap identity fixes
- republish pages after branch cleanup and supervision fixes
- republish pages after adoption and review-identity fixes
- republish pages after migration and progress-budget fixes
- republish pages after chunked hash and inventory fix
- republish pages after seed deletion fix
- republish pages after review-fix commits
- correct re-anchored goal and delegation claims
- republish pages for autonomy self-healing
- record 2026-10-17-autonomy-self-healing interview
- republish checkout pages after inventory re-anchor
- republish installation page for anchored ignore warning
- republish checkout preparation pages after review fixes
- republish checkout preparation pages after merging main
- refresh decoded evidence retrieval claims
- refresh recovery and evidence validation claims
- republish checkout preparation and exclude behavior after review fixes
- republish checkout default and fast-forward recheck
- republish exclude negation ordering after review fix
- republish checkout and exclude pages after review fixes
- publish ultra-goal checkout preparation and exclude defaults
- document ultra-goal checkout preparation and exclude-based ignores
- publish ultra-goal checkout preparation and exclude defaults
- record 2026-10-14-ultra-goal-dirty-checkout-halt interview
- refresh checkpoint recovery evidence

### Maintenance
- Merge pull request #386 from braincrew-lab/fix/release-smoke-legacy-preserve
- Merge pull request #383 from braincrew-lab/feat/autonomy-self-healing
- give the existing-issue fixture row an author
- pin resolution history and merge head in re-resolution test
- Merge pull request #379 from braincrew-lab/fix/ultra-goal-dirty-checkout-halt
- merge main into fix/ultra-goal-dirty-checkout-halt
- Merge pull request #381 from braincrew-lab/fix/ultra-goal-large-recovery-receipts
- Merge remote-tracking branch 'refs/remotes/omb-base/3159399f2a7e728bd18ade4a32702025df5fb1ff6f44ce2624f029a7e50e8c83/main' into fix/ultra-goal-dirty-checkout-halt
- checkpoint before Herdr Verify
- Merge pull request #377 from braincrew-lab/fix/ultra-goal-checkpoint-adoption



## [1.3.1] - 2026-10-07

### Fixed
- write and read .gitignore as utf-8 on windows

### Documentation
- highlight goal and ultra-goal with operating examples
- refresh gitignore evidence after the utf-8 fix

### Maintenance
- Merge pull request #358 from braincrew-lab/fix/gitignore-utf8-append
- Merge pull request #359 from braincrew-lab/docs/readme-goal-guide
- Merge remote-tracking branch 'main' into fix/gitignore-utf8-append
- Merge pull request #357 from braincrew-lab/docs/readme-cleanup



## [1.2.1] - 2026-09-30

### Fixed
- render Kubernetes manifests outside the checkout
- rebase grandfathered skill ceilings on merged main sizes
- harden evidence paths, infra RETRY branch, verifier checks
- preflight ui-verify diffs, Starlette handler, qafix tier 2
- reject deletion of the wiki index in the freshness gate
- include the omb dispatcher in the skill size gate
- correct ultra-review scope-guard claim
- close render, browser-smoke and size-ceiling gaps
- preserve acquired root for delegation cleanup
- require whole-file spec citations and AST-resolved acceptance nodes
- harden cron logs, lock and trace reads and align prompts
- require top-level acceptance tests and align summary body parsing
- check page versions in wiki freshness gate and accept CRLF specs
- annotate spec adapter test overrides for pyright
- trust only the cwd worktree root in codex-launch-args
- preserve delimiter text in spec frontmatter
- trust store parent only for linked worktrees
- accept the cron result marker only on the final line
- verify launchd bootout and restore disabled override on rollback
- validate reused LaunchAgent and report lastRun for removed jobs
- validate launchd Program key in LaunchAgent check
- fall back to resolved localtime path after symlink walk

### Improved
- make spec compliance prompt-guided and split wiki freshness

### Documentation
- reconcile development claims after main merge
- point quickstart at the standalone freshness command
- reconcile merged overview and development claims
- republish spec-optional workflow and standalone freshness gate
- record cwd-lock records_root reuse and relocate claims
- relocate moved freshness test locator
- republish spec lint citation and acceptance rules
- correct launchd and guard claims after ultra-review
- republish knowledge-context for freshness page-version check
- publish spec-driven knowledge workflow to openwiki
- describe worktree-root-only Codex trust (D-025)
- re-point D-025 evidence after trust-root fix
- explain remaining rejected alternatives
- refresh launchd repair claims after review fixes
- record per-launch Codex trust overrides (D-025)
- refresh herdr delegation and cron pages
- align delegation and cronjob docs with fixes

### Maintenance
- Merge pull request #308 from braincrew-lab/feat/harness-prompt-upgrade
- Merge remote-tracking branch 'origin/main' into feat/harness-prompt-upgrade
- Merge pull request #305 from braincrew-lab/feat/openwiki-spec-driven-development
- Merge pull request #309 from braincrew-lab/fix/ultra-review-scope-guard-note
- merge origin/main into feat/openwiki-spec-driven-development
- Merge pull request #303 from braincrew-lab/fix/herdr-codex-startup-trust-dialog
- record core-critique write-capability memory
- merge origin/main into feat/openwiki-spec-driven-development
- merge main into herdr codex trust branch
- Merge pull request #302 from braincrew-lab/fix/herdr-cron-defects-and-prompts
- record core-critique memory from PR 302 review
- raise omb-pr inline CI fix loop cap from 3 to 5
- checkpoint before Herdr Verify
- raise improvement iteration caps from 3 to 5
- checkpoint before Herdr Verify
- checkpoint before Herdr Verify
- checkpoint before Herdr Verify
- checkpoint before Herdr Verify
- narrow json_output before subscript in trace symlink test
- checkpoint before Herdr Verify
- checkpoint before Herdr Verify



## [1.2.0] - 2026-09-29

### Added
- delegate tasks in auto-closing tabs with edit permission
- add Herdr scheduling and retire Hermes

### Fixed
- keep isolation helper failures structured on timeouts and OS errors
- shell-quote the cwd-lock force-release command
- clarify blocked_by_child lock state and strip owned ask rules on uninstall
- serialize cwd-lock mutations and sweep markers before group check
- isolation/cwd-lock helpers, delegate guard, codex startup-dialog gate
- self-source guard for omb update/init
- evidence protocol, run marker sweep, identity-bound kill
- scope pre-launch worktree removal to the blocked gate path
- block escaping relative symlinks and compare file modes
- gate isolated verdict transfer and tracked absolute symlinks
- require committed isolated deliverables and drop absolute symlinks
- reject stacked schedule timezone prefixes
- recover owned runs from fresh process evidence
- roll back activation on native timeouts
- isolate full delegation from a dirty checkout
- trust suffix-less GraphQL bot logins
- narrow optional hook output in herdr guard test
- close ultra-review P1 gaps in delegation push and guard policy
- complete interrupted activation cleanup
- serialize long journal publications
- retry transient journal lock acquisition
- read removed jobs without native lookup
- surface service installation warnings
- roll back unpublished initial prompts
- enable prestart fallback and clean failed staging
- finish removal retries and retire old prompts
- bound draining after launcher exit
- handle exit races and management edge cases
- preserve unresolved owned outcomes
- finalize unstarted wrapper removal
- finalize removal and make log maintenance safe
- preserve occurrence deadlines and retained records
- validate updates and reuse registered tools
- preserve worktree setup portability and ignore ownership
- address scheduler review feedback
- copy OMB skills into managed worktrees
- recover interrupted runs and refresh wiki evidence
- prefer TeamClaude and correct review scope

### Documentation
- update documentation and OpenWiki for herdr hardening
- refresh Herdr isolation evidence for transfer and symlink gates
- re-pin Herdr evidence after merging main
- refresh Herdr delegation evidence for dirty-checkout isolation

### Maintenance
- Merge pull request #301 from braincrew-lab/fix/herdr-hardening-296-300
- Merge pull request #298 from braincrew-lab/fix/herdr-delegation-followups
- Merge remote-tracking branch 'origin/main' into fix/herdr-delegation-followups
- Merge pull request #291 from braincrew-lab/codex/omb-herdr-cronjob
- Merge remote-tracking branch 'origin/main' into fix/herdr-delegation-followups
- Merge pull request #297 from braincrew-lab/fix/herdr-delegate-p1
- merge main into codex/omb-herdr-cronjob
- Merge pull request #294 from braincrew-lab/feat/herdr-delegate-tab
- sync main worktree support
- Merge pull request #292 from braincrew-lab/codex/worktree-skills
- Merge pull request #290 from braincrew-lab/feat/herdr-delegation



## [1.1.6] - 2026-09-27

### Added
- add coordinated issue maintenance

### Fixed
- recover definitive write rejections
- verify source closure boundaries
- narrow issue maintainer test results

### Maintenance
- Merge pull request #289 from braincrew-lab/feat/issue-maintainer
- refresh the generated OpenWiki integration block



## [1.1.5] - 2026-09-24

### Fixed
- stop untracking the harness in the OMB source checkout
- restore the .claude/ harness deleted by e51d243

### Maintenance
- pin the source-checkout rejection



## [1.1.4] - 2026-09-24

### Fixed
- bound the release smoke test by the OpenWiki step budget
- pin the release wrapper contract to its SSOT resource

### Maintenance
- ignore openwiki installer output



## [1.1.1] - 2026-09-22

### Fixed
- preserve historical scope and focused retrieval

### Maintenance
- Merge pull request #287 from braincrew-lab/feat/shared-knowledge-context



## [1.1.0] - 2026-09-21

### Fixed
- harden portable storage and refresh wiki evidence

### Documentation
- document operational memory and refresh onboarding

### Maintenance
- Merge pull request #286 from braincrew-lab/docs/readme-refresh
- Merge pull request #285 from braincrew-lab/feat/operational-memory



## [1.0.4] - 2026-09-20

### Added
- add evidence-based risk review contracts

### Fixed
- tighten ultra-review execution and completion contracts
- register omb-ultra-review in codex preflight skill inventory

### Maintenance
- Merge pull request #284 from braincrew-lab/feat/ultra-review-skill



## [1.0.3] - 2026-09-19

### Maintenance
- Merge pull request #283 from braincrew-lab/feat/openwiki-alignment



## [1.0.2] - 2026-09-10

### Added
- distribute profile resources and support CI-owned releases

### Fixed
- exclude transient caches from resource snapshots

### Improved
- serialize binding journals before writing

### Maintenance
- Merge pull request #282 from braincrew-lab/codex/fix-hermes-version-checks
- derive wrapper expectations from package version
- Merge pull request #281 from braincrew-lab/feat/hermes-profile-distribution
- Merge pull request #280 from braincrew-lab/feat/deep-project-setup



## [1.0.1] - 2026-09-10

### Added
- monitor goals and review pull requests

### Fixed
- stop monitoring closed pull requests

### Maintenance
- Merge pull request #279 from braincrew-lab/feat/hermes-goal-monitor
- Merge pull request #278 from braincrew-lab/fix/hermes-runtime-compat
- format runtime compatibility tests



## [1.0.0] - 2026-09-08

### Fixed
- isolate portable commands and repair linux builds
- satisfy release test formatting and type checks
- deduplicate codex skills across release installs
- refresh codex compatibility files on install

### Documentation
- document rule-loading contract and re-anchor wiki notes

### Maintenance
- Merge pull request #277 from braincrew-lab/codex/fix-v1-release-build
- fix Codex installation and release migration
- Merge pull request #275 from braincrew-lab/feat/rules-lazy-load-hook-optimization
- freeze global-load allowlist and harden omb-goal pipeline hook tests



## [0.9.0] - 2026-09-06

### Added
- add Hermes exports and preserve Codex preflight

### Maintenance
- Merge pull request #274 from braincrew-lab/feat/hermes-skill-compatibility
- Merge pull request #273 from braincrew-lab/feat/codex-review-model-override



## [0.8.9] - 2026-09-05

### Added
- seed gh search allow entry for omb-architect research mode
- sweep Copilot reviews and require a reason on declined comments
- add pr-watch post-PR CI/review follow-through loop

### Fixed
- merge main into refactoring pipeline and harden architect skill contracts
- harden pr-watch lease, target, and revert contracts

### Maintenance
- Merge pull request #269 from braincrew-lab/feat/omb-refactoring-e2e-pipeline
- Merge pull request #272 from braincrew-lab/feat/pr-ci-monitor-review-followup-2
- Merge pull request #271 from braincrew-lab/feat/pr-ci-monitor-review-followup
- stage pr-watch defaults fragment in setup-settings fixture



## [0.8.8] - 2026-09-04

### Documentation
- note omb update cwd behavior and path argument

### Maintenance
- Merge pull request #270 from braincrew-lab/fix/reviewer-bash-prompt-minimization
- apply ruff format to tests/hooks/test_pr_gate.py



## [0.8.7] - 2026-09-02

### Maintenance
- Release v0.8.7


## [0.8.6] - 2026-09-01

### Maintenance
- drop REBASE_HEAD from omb-clean busy markers
- Merge pull request #268 from braincrew-lab/fix/pr-lint-gate-names-a-real-recovery-action



## [0.8.5] - 2026-08-31

### Added
- add --codex delegation flag to fix/plan/plan-review/goal workflows

### Documentation
- document the --codex delegation flag for planning workflows

### Maintenance
- Merge pull request #267 from braincrew-lab/feat/codex-flag-workflows
- Merge pull request #266 from braincrew-lab/feat/codex-flag-workflows
- Merge remote-tracking branch 'origin/main' into feat/codex-flag-workflows
- Merge pull request #265 from braincrew-lab/feat/omb-goal-e2e-hardening
- apply ruff format to codex flag contract test



## [0.8.4] - 2026-08-31

### Added
- add omb:goal autonomous end-to-end pipeline skill

### Fixed
- resolve verification EV-P1 findings

### Documentation
- align pytest commands with timeout SSOT

### Maintenance
- Merge pull request #264 from braincrew-lab/feat/omb-goal-skill
- apply ruff format to goal pipeline contract test
- Merge pull request #263 from braincrew-lab/feat/diff-targeted-tests
- skip dev-wrapper assertions under release-profile omb-cli.sh
- align contracts and apply codex review fixes
- apply ruff format to 5 files failing CI format check



## [0.8.3] - 2026-08-30

### Fixed
- enforce targeted development test runs
- preserve selected worktree ownership
- clarify worktree finalization contract
- preserve blocking domain findings
- block success with incomplete tasks

### Maintenance
- preserve local release configuration



## [0.8.2] - 2026-08-28

### Fixed
- stop tests deleting the real omb binary; detect uv tool installs

### Maintenance
- ignore .deepwork/ local tool state



## [0.8.1] - 2026-08-28

### Fixed
- complete successful discard
- remove unsupported worktree hint
- block when core verifier is lost
- close remediation routing gaps
- bind plan before worktree selection
- preserve interview artifacts across teardown
- guard worktree teardown against dirty state
- harden omb doc workflow contracts
- enforce worktree result contract
- define terminal output contract
- persist worktree execution state
- guard worktree teardown after merge
- align recovery and feedback contracts
- bind pull request safety gates
- gate completion on final checks
- keep plans project-local
- emit terminal workflow status
- require fresh documentation evidence
- allow required agent delegation
- allow required agent delegation
- align adaptive plan verification
- align plan format with runner



## [0.8.0] - 2026-08-10

### Maintenance
- Merge pull request #260 from braincrew-lab/feat/worktree-harness-seed
- apply ruff format to worktree seeding modules



## [0.7.3] - 2026-08-10

### Fixed
- unique prompt filename + delete-on-success for codex skills
- permit the Write tool the codex skills mandate
- prevent command injection in codex skill prompts

### Maintenance
- Merge pull request #258 from braincrew-lab/fix/omb-codex-adv-review-declarative-scroll
- execute the codex prompt-delivery mechanism, not its description
- Merge pull request #259 from braincrew-lab/docs/sot-documentation-integrity
- apply ruff format to test_rules_contract.py
- apply ruff format to codex adv-review contract test



## [0.7.2] - 2026-08-09

### Fixed
- replace omb-explain prime mode with Context Mode

### Maintenance
- Merge pull request #255 from braincrew-lab/fix/omb-explain-radiant-sunbeam



## [0.7.1] - 2026-08-08

### Fixed
- fail worktree-update loudly when no row matches the branch



## [0.7.0] - 2026-08-08

### Added
- add comprehension layer to explanation contract

### Fixed
- prevent skill injection from prose documentation

### Improved
- optimize omb-plan workflow and instruction budget

### Maintenance
- Merge pull request #254 from braincrew-lab/fix/skill-injection-prose-collision
- apply ruff format to skill injection hygiene test
- Merge pull request #253 from braincrew-lab/feat/omb-plan-robust-flute
- Merge pull request #252 from braincrew-lab/feat/explain-comprehension-layer
- Merge pull request #251 from braincrew-lab/ci/restore-public-release-mirror
- restore public release mirroring to the distribution repo
- Merge pull request #250 from braincrew-lab/fix/ruff-format-release-fixtures



## [0.6.3] - 2026-08-07

### Fixed
- remove trailing blank line failing ruff format check
- apply rendered notes to a CI-created release

### Documentation
- record codex compat contract narrowing in ADR

### Maintenance
- Merge pull request #251 from braincrew-lab/ci/restore-public-release-mirror
- restore public release mirroring to the distribution repo
- Merge pull request #250 from braincrew-lab/fix/ruff-format-release-fixtures
- Merge pull request #249 from braincrew-lab/fix/codex-agent-role-toml



## [0.2.14] - 2026-05-04

### Documentation
- add Agent Team primitive spike ADR (PR 0)

### Maintenance
- Merge pull request #124 from braincrew-lab/feat/agent-team-compatibility-spike
- apply ruff format to test_team_spike_findings.py
- Merge pull request #121 from braincrew-lab/feat/upstream-harness-monitor



## [0.2.13] - 2026-05-03

### Maintenance
- Merge pull request #118 from braincrew-lab/feat/orm-tortoise-first
- apply ruff format to check-raw-sql.py



## [0.2.12] - 2026-05-03

### Maintenance
- Merge pull request #117 from braincrew-lab/fix/exitplanmode-silent-approval
- apply ruff format to ExitPlanMode guard files



## [0.2.11] - 2026-05-01

### Fixed
- preserve user-customized CLAUDE.md in omb update

### Maintenance
- Merge pull request #116 from braincrew-lab/fix/omb-update-snappy-marble
- Merge pull request #115 from braincrew-lab/fix/permission-auto-approve
- apply ruff format to settings_merge and omb_setup_settings tests



## [0.2.10] - 2026-05-01

### Maintenance
- Merge pull request #114 from braincrew-lab/chore/migrate-org-to-braincrew-lab



## [0.2.10] - 2026-05-01

### Maintenance
- Merge pull request #114 from braincrew-lab/chore/migrate-org-to-braincrew-lab



## [0.2.9] - 2026-05-01

### Fixed
- reject HOME/root/harness paths before missing-claude early exit

### Improved
- sync UI rules and wiki to zustand for global state

### Documentation
- translate zustand.md "역할 분리" section to English
- replace tanstack-store with zustand and expand tanstack-query

### Maintenance
- Merge pull request #112 from braincrew-lab/feat/omb-uninstall
- apply ruff format and fix import sort to satisfy CI
- Merge pull request #113 from braincrew-lab/refactor/ui-rules-zustand-sync
- grandfather oversize zustand.md and tanstack-query.md



## [0.2.8] - 2026-04-30

### Maintenance
- Merge pull request #111 from braincrew-lab/fix/omb-update-mutable-stroustrup
- apply ruff format to fix/omb-update changes



## [0.2.7] - 2026-04-30

### Maintenance
- Merge pull request #110 from braincrew-lab/fix/shell-claude-project-dir-fallback
- apply ruff format to test_shell_wrapper_fallback.py
- integrate origin/main into fix branch



## [0.2.6] - 2026-04-30

### Added
- standardize next-step AskUserQuestion across pipeline skills
- add LangGraph streaming transport convention (Redis Streams + SSE)

### Documentation
- document pipeline next-step AskUserQuestion prompts

### Maintenance
- Merge pull request #109 from braincrew-lab/feat/pipeline-next-step-prompts
- normalize next_step_hint reminder wording in omb-codex-adv-review
- Merge pull request #107 from braincrew-lab/fix/omb-codex-preflight
- Merge pull request #108 from braincrew-lab/feat/langgraph-streaming-transport
- apply ruff format to codex preflight tests
- update codex preflight tests to new 3-signal contract



## [0.2.5] - 2026-04-29

### Added
- add TanStack frontend stack enforcement rules and wiki notes

### Documentation
- integrate TanStack Query/Table/Form references

### Maintenance
- Merge pull request #106 from braincrew-lab/feat/tanstack-frontend-stack
- apply ruff format to rules-fm-check.py
- Merge pull request #105 from braincrew-lab/feat/codex-auto-update
- apply ruff format to codex auto-update changes



## [0.2.4] - 2026-04-29

### Documentation
- tweak whitespace in prompt-evaluation note

### Maintenance
- Merge pull request #104 from teddynote-lab/fix/pyinstaller-missing-bin-resources
- apply ruff format to new regression tests



## [0.2.3] - 2026-04-29

### Maintenance
- Merge pull request #103 from teddynote-lab/fix/omb-init-bin-wrappers



## [0.2.2] - 2026-04-25

### Improved
- remove stub redirects after migration to common/
- restructure .claude/rules/ for progressive disclosure

### Documentation
- remove external attribution from coding-principles
- refresh 30_Constraints notes after rules restructure
- migrate rules paths and document agent rules: frontmatter

### Maintenance
- Merge pull request #102 from teddynote-lab/refactor/rules-stub-cleanup
- Merge pull request #101 from teddynote-lab/refactor/claude-rules-happy-blanket
- ruff format test_rules_contract.py



## [0.2.1] - 2026-04-21

### Fixed
- use canonical pipe form in omb-tag prose reference

### Improved
- remove guidance HTML comments from omb-setup CLAUDE.md template
- exclude 99_Settings/ registry from INDEX.md

### Documentation
- expand tags REGISTRY with 122 tech-spec tags

### Maintenance
- Merge pull request #98 from teddynote-lab/docs/wiki-tags-registry-expand
- Merge pull request #99 from teddynote-lab/refactor/omb-setup-claude-md-reactive-turtle
- accept slash-delimited prose in canonical status guard
- Merge pull request #97 from teddynote-lab/refactor/wiki-index-exclude-settings
- apply ruff format to test_wiki_index_rebuild.py



## [0.2.0] - 2026-04-21

### Added
- add DEV_NOTE PR-style template and body-structure rule
- add v2 schema foundation - ADR-003, 5 templates, 6 rules, vocab MOCs
- optimize omb-prompt-guide and omb-prompt-review for Claude 4.7

### Fixed
- tag validation bug + keywords/change-type rules
- remove 6 more orphan v1 skill tests
- remove orphan v1 tests and stale hook-conventions reference
- replace literal f-string placeholder in fact-43
- resolve verify CV-P1 findings

### Improved
- update 6 orchestrator skills + root docs for v2 paths
- v2 scripts, SKILL rewrite, hook + graph cleanup, content migration
- canonicalize omb status vocabulary

### Documentation
- update README + skills/agents/architecture for v2
- sync for PR #88 focus-ring rule
- sync wiki for status vocabulary canonicalization
- capture prompt-guide/evaluation/review 4.7 update
- replace placeholder with apps/web/src in fallback check

### Maintenance
- Merge pull request #96 from teddynote-lab/fix/wiki-vocab-tags-keywords
- apply ruff format
- Merge pull request #95 from teddynote-lab/feat/wiki-dev-note-template
- Merge pull request #94 from teddynote-lab/feat/wiki-v2-obsidian-native
- apply ruff format to 6 scripts/tests
- update path-script regression test for wiki-summary.sh rename
- add script tests + migrate sensitive-guard to @security-audit
- Merge pull request #91 from teddynote-lab/docs/wiki-sync-focus-ring
- regenerate graph.json post-merge
- merge origin/main — accept canonical fact-43 phrasing
- Merge pull request #92 from teddynote-lab/docs/wiki-status-vocabulary-sync
- update INDEX timestamps for SPEC and ADR-002 after merge
- merge main into docs/wiki-status-vocabulary-sync
- merge origin/main, regenerate INDEX and graph files
- Merge pull request #93 from teddynote-lab/docs/wiki-prompt-4-7-lessons
- extend placeholder skip in status vocabulary gate
- merge origin/main into docs/wiki-prompt-4-7-lessons
- Merge pull request #90 from teddynote-lab/refactor/canonicalize-status-vocabulary
- Merge pull request #89 from teddynote-lab/feat/prompt-guide-4-7-optimization
- apply ruff format to test_status_vocabulary.py
- Merge pull request #88 from teddynote-lab/feat/focus-ring-transient-yao



## [0.1.38] - 2026-04-20

### Improved
- integrate Karpathy coding principles across agents

### Documentation
- merge environment variables section

### Maintenance
- Merge pull request #87 from teddynote-lab/refactor/karpathy-coding-principles
- apply ruff format to assert_rubric_weights_sum_to_1.py



## [0.1.37] - 2026-04-20

### Maintenance
- Merge pull request #86 from teddynote-lab/refactor/omb-federated-peach



## [0.1.36] - 2026-04-20

### Maintenance
- Merge pull request #85 from teddynote-lab/fix/omb-update-preserve-user
- apply ruff format to fix bug fix



## [0.1.35] - 2026-04-19

### Documentation
- document update-gitignore subcommand and init step 9

### Maintenance
- Merge pull request #84 from teddynote-lab/feat/auto-gitignore-harness
- apply ruff format to gitignore migration code



## [0.1.34] - 2026-04-19

### Added
- self-evolving methodology-first feedback loop

### Fixed
- bundle omb-*-settings scripts into harness tarball

### Improved
- remove v1->v2 migration path - single-version clean init
- v1→v2 category restructure — core 7 + adaptive profiles

### Documentation
- seed code_convention and enforce lint contract

### Maintenance
- Merge pull request #83 from teddynote-lab/feat/omb-wiki-kind-boot
- apply ruff format to new feedback-loop tests
- preserve historical MIGRATE-V2 audit log line
- merge refactor/wiki-strip-v2 - remove v1->v2 migration path
- Merge pull request #82 from teddynote-lab/refactor/wiki-categories-v2
- apply ruff format to test_profile_detection
- Merge pull request #81 from teddynote-lab/fix/release-bundle-setup-scripts



## [0.1.33] - 2026-04-19

### Fixed
- narrow parse() return type for pyright in test_yaml_mini

### Documentation
- close §7 gaps — SKILL.md, wiki-reviewer, INDEX rebuild

### Maintenance
- Merge pull request #80 from teddynote-lab/feat/wiki-graphify-alignment
- untrack agent-memory/code-test, revert wiki build artifacts
- apply ruff format to graphify alignment files



## [0.1.32] - 2026-04-18

### Maintenance
- Merge pull request #79 from teddynote-lab/fix/release-patch-omb-cli-sh
- apply ruff format to release workflow test



## [0.1.31] - 2026-04-18

### Maintenance
- Merge pull request #78 from teddynote-lab/feat/omb-wiki-graph-integration
- untrack hypothesis test cache
- apply ruff format to new test and handler files
- merge main into feat/omb-wiki-graph-integration



## [0.1.30] - 2026-04-18

### Maintenance
- Merge pull request #77 from teddynote-lab/feat/omb-pr-preflight-conflict



## [0.1.29] - 2026-04-18

### Added
- sync main from remote after omb:clean teardown

### Fixed
- auto-route omb:fix and omb:plan in Plan Mode

### Improved
- remove AUTO-GENERATED markers from omb-setup template
- extract fix-writer section-structure into rule file

### Maintenance
- enable OMB_USE_CODEX in project settings
- Merge pull request #76 from teddynote-lab/feat/omb-clean-foamy-star
- Merge pull request #75 from teddynote-lab/chore/remove-deprecated-skills
- remove deprecated omb-deploy-vercel, omb-vercel-cli, omb-pgvector-search
- Merge pull request #74 from teddynote-lab/fix/omb-fix-plan-mode-support
- Merge pull request #73 from teddynote-lab/fix/codex-use-scope



## [0.1.28] - 2026-04-18

### Fixed
- preserve user hooks in omb-setup-settings merge

### Maintenance
- Merge pull request #72 from teddynote-lab/fix/setup-settings-array-merge
- ruff format test_omb_setup_settings.py



## [0.1.27] - 2026-04-18

### Fixed
- enforce canonical Section 3/4 in plan output + add plan-mode preflight

### Improved
- redesign CLAUDE.md v2 schema with 150-line cap

### Maintenance
- Merge pull request #71 from teddynote-lab/refactor/omb-setup-claude-md-v2
- resolve conflicts with main (SPEC.md/INDEX.md wiki)
- Merge pull request #70 from teddynote-lab/fix/omb-fix-plan-format
- Merge pull request #69 from teddynote-lab/fix/wiki-realpath-macos



## [0.1.26] - 2026-04-17

### Added
- display effort level from settings

### Documentation
- always run omb:wiki init, remove optional prompt

### Maintenance
- Merge pull request #68 from teddynote-lab/fix/codex-skills-preflight-127
- apply ruff format to test_codex_preflight.py



## [0.1.25] - 2026-04-16

### Maintenance
- Release v0.1.25


## [0.1.24] - 2026-04-15

### Added
- add /omb:fix skill for bug-fix plan authoring
- add centralized settings reader and gate Codex integration
- auto-install jq during omb init/update

### Fixed
- replace wiki-route-guard keywords to fix false positives
- resolve merge conflicts with main
- resolve merge conflict and drift gate precision
- add OMB_DEBUG trace logging for SKILL.md permission prompt diagnosis

### Maintenance
- Merge pull request #67 from teddynote-lab/feat/omb-fix-skill
- Merge pull request #66 from teddynote-lab/fix/skill-md-permission-prompt
- apply ruff format to test_permission_request
- Merge pull request #65 from teddynote-lab/feat/codex-settings-env
- resolve conflict with origin/main for cli.md frontmatter
- Merge pull request #64 from teddynote-lab/feat/auto-install-jq
- apply ruff format to new modules and tests
- ruff format test_update_command.py
- ruff format new files
- rephrase drift marker mentions in log prose



## [0.1.23] - 2026-04-15

### Maintenance
- Release v0.1.23


## [0.1.22] - 2026-04-14

### Maintenance
- Release v0.1.22


## [0.1.21] - 2026-04-14

### Maintenance
- Merge pull request #63 from teddynote-lab/fix/wiki-writer-routing



## [0.1.20] - 2026-04-14

### Added
- authoritative code-convention wiki + omb:run auto-load

### Fixed
- auto-approve all .claude/ writes including settings

### Maintenance
- inject wiki env defaults
- Merge pull request #62 from teddynote-lab/fix/claude-auto-approve-all
- Merge pull request #61 from teddynote-lab/feat/wiki-code-conventions
- apply ruff format to test_permission_request
- Merge pull request #60 from teddynote-lab/fix/ship-commands-in-releases
- apply ruff format to test_release_workflow.py



## [0.1.19] - 2026-04-14

### Added
- auto-inject wiki env defaults via omb init and /omb:wiki init

### Fixed
- force cron-status --all in omb-cron to prevent hidden jobs

### Documentation
- scaffold project blueprint wiki for monorepo

### Maintenance
- sync omb-release with README badge and content updates
- Merge pull request #59 from teddynote-lab/feat/snoopy-inventing-key
- apply ruff format to test_omb_wiki_settings.py



## [0.1.18] - 2026-04-14

### Added
- add omb:wiki blueprint wiki skill

### Improved
- split model rendering into Line 5 of statusline

### Documentation
- add omb:wiki core feature section

### Maintenance
- Merge pull request #56 from teddynote-lab/refactor/statusline-5line-layout
- sync main into statusline-5line-layout
- Merge pull request #58 from teddynote-lab/chore/ruff-format-fix
- apply ruff format to 4 python files
- Merge pull request #57 from teddynote-lab/feat/omb-wiki-skill
- apply ruff format to pass python-lint CI



## [0.1.17] - 2026-04-14

### Maintenance
- drop darwin/amd64 build, support darwin/arm64 only



## [0.1.16] - 2026-04-14

### Maintenance
- Release v0.1.16


## [0.1.15] - 2026-04-13

### Added
- add post-PR conflict and CI verification to omb-pr
- add omb:cron skill for scheduling Claude Code tasks
- add issue claim mechanism to omb-resolve-issue
- add omb init survey and Slack notification module
- add --bypass flag to omb-resolve-issue

### Fixed
- add explicit os import to cron handlers for CI ruff
- add resolve_project_dir() fallback for manual CLI usage
- auto-approve .claude/ writes via PreToolUse
- update script path in test_setup_settings

### Maintenance
- Merge pull request #54 from teddynote-lab/feat/omb-cron
- apply ruff format to cron files
- Merge pull request #55 from teddynote-lab/feat/omb-pr-post-verification
- Merge pull request #53 from teddynote-lab/feat/omb-init-survey
- apply ruff format to new test files
- Merge pull request #50 from teddynote-lab/feat/issue-claim-mechanism
- Merge pull request #52 from teddynote-lab/feat/omb-resolve-bypass
- apply ruff format to test_worktree_handlers
- Merge pull request #51 from teddynote-lab/fix/protected-dir-pretooluse-approve
- Merge pull request #49 from teddynote-lab/feat/omb-resolve-bypass



## [0.1.14] - 2026-04-13

### Maintenance
- Release v0.1.14


## [0.1.12] - 2026-04-13

### Fixed
- revert linux build to direct runner execution
- replace bare except Exception with specific types
- add non-root USER directive to api and ai Dockerfiles

### Documentation
- fix broken blockquote in issue scanner example

### Maintenance
- remove gitleaks secret scanning configuration
- Merge pull request #48 from teddynote-lab/fix/issue-34-error-handling
- Merge pull request #47 from teddynote-lab/fix/issue-40-docker-root-user-directive
- Merge pull request #46 from teddynote-lab/fix/issue-19-chat-pydantic-validation



## [0.1.10] - 2026-04-13

### Maintenance
- Release v0.1.10


## [0.1.9] - 2026-04-13

### Maintenance
- Release v0.1.9


## [0.1.8] - 2026-04-13

### Maintenance
- Merge pull request #45 from teddynote-lab/fix/glibc-compat-linux-binary
- Update .github/workflows/release-binary.yml



## [0.1.7] - 2026-04-13

### Added
- expand omb-postgres references and rules content
- add omb-resolve-issue skill for end-to-end GitHub issue resolution

### Fixed
- add package-lock.json for dependency pinning
- eliminate shell injection in omb-setup-settings.sh Python fallback
- log worktree-status DB errors to stderr
- validate column names in update_status against allowlist
- resolve all CI workflow failures
- use vitest --passWithNoTests CLI flag
- use vitest --passWithNoTests CLI flag
- use vitest --passWithNoTests CLI flag
- allow vitest to pass with no test files
- allow vitest to pass with no test files
- allow vitest to pass with no test files
- add missing jsdom dependency for vitest
- add missing jsdom dependency for vitest
- add missing jsdom dependency for vitest
- add missing @tailwindcss/postcss dependency
- add missing @tailwindcss/postcss dependency
- add missing @tailwindcss/postcss dependency
- add git config for tests and fix eslint dependencies
- add git config for tests and fix eslint dependencies
- add git config for tests and fix eslint dependencies
- add turbo type-check task and suppress certifi import
- add turbo type-check task and suppress certifi import
- add turbo type-check task and suppress certifi import
- scope pyright, add packageManager, fix commit-lint perms
- scope pyright, add packageManager, fix commit-lint perms
- scope pyright, add packageManager, fix commit-lint perms
- resolve CI workflow failures
- resolve CI workflow failures
- resolve CI workflow failures
- update CLAUDE.md verification strategy references
- enforce hook directory conventions

### Improved
- restructure PR and issue templates for improved LLM readability

### Documentation
- add 19 missing agents to CLAUDE.md Sub-Agent Inventory

### Maintenance
- reorder settings.json keys and expand gitignore
- Merge pull request #32 from teddynote-lab/fix/issue-18-missing-package-lock
- Merge pull request #33 from teddynote-lab/fix/issue-15-shell-injection-setup-settings
- fix ruff format on test_setup_settings.py
- Merge pull request #38 from teddynote-lab/fix/issue-21-silent-exception
- Merge pull request #31 from teddynote-lab/fix/issue-16-sql-fstring-column
- apply ruff format to test_worktree_db.py
- Merge pull request #30 from teddynote-lab/fix/issue-14-remove-dead-shared-pkg
- remove unused packages/shared dead code
- Merge pull request #29 from teddynote-lab/refactor/pr-issue-fix
- Merge pull request #27 from teddynote-lab/fix/issue-22-docs-verification
- Merge pull request #26 from teddynote-lab/fix/issue-13-missing-agent-inventory
- Merge pull request #25 from teddynote-lab/fix/issue-12-hook-convention
- Merge pull request #24 from teddynote-lab/feat/omb-resolve-issue



## [0.1.6] - 2026-04-12

### Added
- add --bypass flag to omb-issue for /loop automation
- register omb-issue as omb:issue slash command

### Fixed
- include plan file absolute path in codex review prompts

### Maintenance
- build tarball from source, remove .claude/ from release repo
- stop copying CLAUDE.md to release repo



## [0.1.5] - 2026-04-13

### Fixed
- Install script now always updates `omb` symlink even when an older binary exists
- PyInstaller binary bundles certifi CA certificates to fix SSL errors on macOS
- HTTP downloader uses certifi SSL context for reliable HTTPS connections

## [0.1.4] - 2026-04-13

### Fixed
- Fixed release pipeline that caused all previous releases (v0.1.1-v0.1.3) to ship with zero assets
- CI publish job now tolerates partial build failures across platforms
- Install script URL corrected (no longer returns 404)
- Binary download asset naming aligned with CI output format
- Hooks and statusline script now properly included in harness distribution
- Eliminated race condition between manual release skill and CI pipeline

## [0.1.3] - 2026-04-13

### Added
- `omb:issue` skill for automated codebase scanning and GitHub issue creation
- `omb:git-setup` skill for git workflow setup with pre-commit hooks and GitHub Actions
- `.gitignore` management integrated into `omb init`
- Documentation language support for PR, issue, and plan skills
- Git hooks and GitHub Actions CI workflows

### Fixed
- Statusline width detection for non-TTY and narrow terminal environments
- PR creation workflow compatibility with worktree environments
- Language environment variable resolution in agents and skills

### Changed
- Updated PR labels and added label sync to git-setup workflow

## [0.1.2] - 2026-04-12

### Changed
- Codex skills renamed for improved consistency
- PR template enhanced with language support and conditional sections
- `omb:document` renamed to `omb:doc` for brevity
- README restructured with usage examples and workflow documentation

### Fixed
- Statusline now uses project root for folder name and displays rate limit reset time

## [0.1.1] - 2026-04-12

### Added
- CLI commands: `omb init`, `omb update`, and `omb version` for harness installation and management
- SQLite-based worktree state management with persistent tracking across sessions
- Verification skill (`omb:verify`) with parallel verifier pool
- Codex CLI integration for code review, adversarial review, and task delegation
- Release pipeline for automated version bumping, changelog, and publishing
- Plan review parallelization across multiple reviewer agents
- Evidence-anchored prompt evaluation with binary rubric scoring

### Changed
- Renamed CLI binary to `oh-my-braincrew` with `omb` as primary command
- Unified ticket schema for all evaluation, review, and verification workflows
- TDD practices integrated across all implementation and verification agents

### Fixed
- Git branch name display in statusline
- Hook fallback for manual invocations

---

## Legacy (v0.2.x)

> The v0.2.x series used a plugin-based architecture that has been replaced by the current harness architecture in v0.1.x. These versions are no longer supported.

<details>
<summary>v0.2.6 — v0.2.17 (2026-04-05 to 2026-04-09)</summary>

- v0.2.17: Fixed Codex hooks and plugin manifest path
- v0.2.16: Added Codex plugin integration, lint checks during verification
- v0.2.15: Pipeline recovery and resilience improvements
- v0.2.14: Codex plugin installation, hook reliability fixes
- v0.2.13: Pipeline stall recovery, hook decision logging
- v0.2.12: Dual-path installation guide, checkpoint setup docs
- v0.2.11: Language settings in setup wizard
- v0.2.10: PROJECT.md, Slack notifications, pipeline stability
- v0.2.9: `omb progress` and `omb sync` commands
- v0.2.8: Hook and auto-update fixes
- v0.2.7: `omb init` command
- v0.2.6: Cross-platform binary distribution, one-liner installers

</details>
