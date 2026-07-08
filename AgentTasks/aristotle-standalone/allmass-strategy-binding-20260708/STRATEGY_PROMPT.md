# Strategy + formalization design: the Δ binding-energy finite invariant (T3b)

You are the program's chief strategist and top Lean formalization architect. This
is a STRATEGY + DESIGN job (a proof is welcome if one is cheap, but the deliverable
is a *plan*, not necessarily a completed proof). Context files in `src/`.

## The situation (finite mathematical-physics program: mass = obstruction to null transport)

The §3↔§4 "bridge" asks whether the operator ground mass equals the kinematic
Plücker mass `det P`. It **splits** (see `DELTA_BINDING_ENERGY_FINDING.md`):

- **Free half (0b-a): PROVED** (`FreeMassBridge.lean`, kernel-checked): for a free
  (flat-transport) two-edge carrier, `P · adjugate P = det P • 1`, so the operator
  mass IS the kinematic mass.
- **Interacting half (0b-b): OPEN.** Turning on closure strength `t`, the sector's
  least eigenvalue drops *below* `det P` by `Δ := min spec − det P = −t < 0` (a
  numeric-oracle finding, `probe_bridge_binding_energy.py`). `Δ` is negative,
  closure-controlled, and **off-diagonal** (invisible to the naive constituent
  estimate) — the finite shadow of "a bound state's mass is not naively assembled
  from its constituents." Reaching `min spec = 0` at `t = aperture` reproduces the
  massless-bound-state critical line.

The mass-gap block `B(λ,κ)` (in `MassGapWitness.lean`, fully kernel-checked:
`B_least_eigenvalue`, `B_posDef_iff`) is the same physics at the block level:
least eigenvalue `λ − κ`.

## The target — make `Δ` a finite invariant (grade C → M path)

The program wants to promote `Δ` from "a numeric-oracle observation" to a
**kernel-statable finite invariant** with a proved property. Your job:

1. **Define `Δ` cleanly.** Propose the precise Lean-statable definition of the
   binding-defect invariant `Δ` for a finite interacting carrier — e.g.
   `Δ(H, P) := (least eigenvalue of the sector mass form) − det P`, or a better
   formulation you argue for. State the exact types (matrices? operators? which
   sector?) and why.
2. **State the theorem you'd prove.** The conjecture is that `Δ` is *negative and
   closure-controlled* (governed by the closure/turn expectations, off-diagonally).
   Give the sharpest TRUE finite statement you can — ideally one already visible in
   the `B(λ,κ)` block model (where `Δ = (λ−κ) − det?`... work out what `det P` even
   is at the block level and whether `Δ = −κ`-type identities hold and are
   provable). A clean block-level lemma `Δ_block = −κ` (or similar), kernel-provable,
   would be a real first win.
3. **Prove it if cheap, else give the proof strategy.** If a block-level `Δ`
   identity is a short Mathlib proof (using `B_least_eigenvalue` / `B_det`), deliver
   it as Lean. Otherwise give a concrete proof plan: key lemmas, the Mathlib API,
   and the main obstruction.
4. **Kill condition + no-go analysis.** The pre-registered kill is "a carrier where
   `Δ > 0` or `Δ` is uncorrelated with closure." Is that kill well-posed? Could `Δ`
   be positive for some physical carrier (would that break the binding-energy
   reading)? Give the honest risk.

## Required output

- **`Δ` definition** (precise, Lean-statable, with rationale).
- **The theorem statement** you recommend (sharpest true finite claim), plus a
  Lean proof if cheap, else a ranked proof plan.
- **A block-level concrete result** for `B(λ,κ)` if one exists (this is the highest
  -value quick win — a kernel `Δ` identity).
- **No-go / kill analysis** and the single biggest risk to the binding-energy
  interpretation.

Be specific and technical. A correct small kernel-provable `Δ` identity beats a
long informal essay.
