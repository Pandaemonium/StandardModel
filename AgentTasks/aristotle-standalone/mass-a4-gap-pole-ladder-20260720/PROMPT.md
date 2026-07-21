# Strategy/design job: the gap-to-pole reconstruction ladder (gate A4)

Type: theorem-design / proof-architecture (deliverable: a rigorous ladder
specification with exact intermediate statements + the one named missing
analytic lemma; plus any self-contained Mathlib-only rung you can prove). AFPL
gate A4.

## Landed inputs (kernel-checked, standard three)

- `gap_does_not_fix_pole`: equal spectrum, physical weight 1 vs 0 (the physical-
  sector overlap is independent data).
- `transfer_gap_does_not_fix_correlation_mass`: composite-mass readout is
  observable dependent.
- `resolvent_response_entries` / `resolvent_residue_pole_vs_zero`: at the
  correlator level, `(z+1)^-1` pole vs `(z-1)^-1` regular at the shared gap edge.

So the negative direction is settled: an internal gap is not a physical mass
without the physical-sector overlap. This job designs the POSITIVE
reconstruction ladder.

## Deliverable: the five-rung ladder (exact statements)

Specify, with precise Lean-targetable statements and hypotheses, the ladder from
an internal finite spectral gap to a physical mass, grounded in the
Kallen-Lehmann spectral representation and (for the Euclidean branch)
Osterwalder-Seiler reflection positivity:

1. a self-adjoint (or unitary) evolution and a positive physical sector
   (state the positivity/self-adjointness hypothesis exactly);
2. a resolvent or two-point response with a spectral feature at the gap edge and
   a NONZERO physical-sector residue (the condition that rules out the
   propagator-zero case, using the landed obstruction);
3. the dispersion relation near the selected sector (the map momentum -> energy
   whose minimum is the rest mass);
4. a changing-lattice limit with stated regularity/normalization (Sobolev or
   Schwartz domain; cite the Arrighi-Forets-Nesme continuum template);
5. the exact condition under which the limiting pole/rest energy is CALLED a
   mass (nonzero KL spectral weight + correct dispersion + convergence).

For each rung: state it, mark whether it is (a) already landed, (b) provable now
with Mathlib, or (c) an open analytic lemma; if (c), name the single missing
lemma precisely. Prove at least one rung that is currently type (b) as a
self-contained Mathlib-only lemma (candidate: rung 2, the nonzero-residue
condition abstracted from the landed obstruction; or rung 1, positive-sector
self-adjointness bookkeeping).

## Constraints

Mathlib only for any Lean; no new `axiom`/`opaque`/`unsafe`; no `native_decide`;
standard axioms. Report axioms. Success: the five-rung ladder with each rung
graded (landed / provable-now / open-lemma-named) + one type-(b) rung proved.
