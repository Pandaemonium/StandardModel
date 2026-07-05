# Autonomous run status brief (for Fable)

Standalone orientation for Claude Fable 5, used as a strategy/design/red-team
resource. Assume you are blind to this repository and the chat history; this
document gives you the high-level picture. Date: 2026-07-05 (day 2 of a
four-day run).

## What this is

A Lean 4 (Mathlib, pinned `v4.28.0`) formalization run on lattice Yang-Mills /
the mass-gap ladder, extended (mid-run, user-directed) toward a finite lattice
QCD mass formalism, and (also user-directed) toward the program's own
distinctive "null-edge" mass mechanism. Two co-equal autonomous agents -
"claude" (this agent) and "codex" - work the same git tree, coordinating via a
shared LEDGER (task board + Aristotle registry + heartbeats) and DISCUSSION
(design/review threads). Aristotle (Harmonic's proof agent) is a third partner:
we prepare typechecking statement-freeze scaffolds, submit focused Mathlib-only
packages, and INDEPENDENTLY re-verify every returned proof against our pinned
toolchain before integrating (Aristotle's own build claims are made against its
sandbox and have twice masked replay failures we caught locally). Everything is
draft-trust; no promotion to trusted this run. Every claim carries a label and
the finite-lattice / fixed-coupling / fixed-volume boundary; the continuum limit
is permanently out of scope.

## Mission, in three parallel threads

- **T-A: standard confinement / YM mass gap** (Track A of the program doc,
  section 14, items Q1-Q11): reflection positivity for the Wilson ensemble,
  transfer operator, Kotecky-Preiss cluster expansion, YM1 area law.
- **T-QCD: the QMF ladder** (section 15, user-directed aggressive extension,
  rungs QMF1-QMF8): compact-group substrate, Grassmann/Berezin finite formalism,
  Wilson-Dirac operator, fermionic reflection positivity, QCD transfer + hadron
  quantum-number sectors, culminating (QMF7) in hadron masses as
  sector-restricted spectral gaps. QMF8 = continuum, recorded as the named
  frontier, never claimed.
- **T-NE: the genuine null-edge mass mechanism** (the program's distinctive
  claim; Gate I1 = the Plucker "mass as obstruction geometry" identity,
  `det P = m^2`). This is the least-established, highest-originality thread.

## Current status (proved = kernel-checked, standard axioms, independently
verified)

Proved and integrated:
- T-A: RP-LINK zero-cut tier CLOSED including genuine ensemble identification,
  after a real refutation (the naive mirror-holonomy convention was proved FALSE
  by an S3 counterexample) and a redesign (group inverse in the reflection
  pullback). Q4/Q5 (vacuum dominance, string-tension nonnegativity, fusion
  eigenvalue reality/ordering) UNCONDITIONAL. The **Penrose tree-graph
  inequality** (`|ursellSum G| <= spanningTreeCount G`, the hardest single
  combinatorial theorem on the ladder, absent from Mathlib) PROVED. Q11 tree-slice
  lasso identity PROVED. A four-layer finite OS/GNS transfer-Hilbert stack.
- T-A honest negative: the bare Kotecky-Preiss C2 convergence bound is FALSE
  without self-incompatibility - a kernel-checked one-point counterexample.
- T-QCD: **QMF3** (finite Matthews-Salam: Berezin/Grassmann Gaussian integral =
  determinant) and **QMF4** COMPLETE (Euclidean Clifford algebra + Wilson-Dirac
  gamma5-hermiticity => real determinant => paired-flavor determinant positivity).
  The fermionic-determinant algebra of lattice QCD is now finite-formalized.
- T-NE: the mass -> von Neumann entropy dictionary. Headline theorem "null edges
  do not age": the observer-conditioned entropy of the normalized visible-momentum
  block is zero exactly when the momentum is massless; any mass forces strictly
  positive mixedness; endpoints null=pure and rest=maximally-mixed; tied to the
  invariant ratio m/E.

In flight / owned by codex: the M1 cut-plaquette RP construction, the M2
Kotecky-Preiss rooted tree-sum bound (the analytic convergence crux), Q7
strong-coupling polymer map.

## The strategic picture: three mountains + two ladders

The T-A critical path has narrowed to **three mountains**:
- **M1 - cut-plaquette RP** (the genuinely nontrivial Osterwalder-Seiler content;
  the zero-cut case is degenerate).
- **M2 - the KP combinatorial core** (Penrose DONE; the rooted tree-sum
  convergence bound remains).
- **M3 - a physical Wilson transfer operator** (the OS/GNS stack is complete but
  entirely abstract-kernel-level; no spectral gap yet).

Key leverage point: M1 and M3 share their missing object - one concrete
cut-bearing reflection lattice with the Wilson slab weight in mirror
coordinates. Build it once, serve both.

The T-QCD ladder rides on top: QMF1/QMF3/QMF4 done; QMF5 (fermionic RP) is next
and can be designed abstractly on the existing RP-KER + Berezin + Wilson-Dirac
layers; QMF6/QMF7 (transfer + hadron sectors + mass statement) are the endpoint.

## Honest frontier (NOT done)

- No physical mass gap / spectral gap of a genuine transfer operator anywhere yet.
- Full RP-LINK with cut plaquettes (M1) open; KP convergence crux (M2) open.
- T-NE is finite algebra / reconstruction only: no positivity/spectral statement,
  no no-doubling determinant proof for the null-edge operator, no derived (vs
  inserted) mass scale. Its distinctive claims are labeled reconstruction, not
  new physics.
- The continuum limit is permanently out (QMF8); nothing here approaches the Clay
  YM mass-gap problem's analytic content.

## Where Fable input is most valuable

Highest-leverage strategy questions right now: (1) the cleanest finite
formalization of fermionic (Grassmann-valued) reflection positivity building on
the existing abstract RP kernel + the finite Matthews-Salam determinant (QMF5
design); (2) the shared M1/M3 cut-bearing-lattice + slab-weight construction and
its spectral-decomposition route into a PSD cut kernel; (3) pressure-testing the
null-edge (T-NE) claims for any accidental overclaim past "reconstruction /
finite identity", especially the unnormalized-invariant vs
observer-conditioned-entropy boundary. Fable answers are LEADS, not proof - the
Lean kernel remains the source of truth, and every Fable call's primary ask
should be a super-stretch deliverable (a full design / proof DAG), never a mere
opinion.
