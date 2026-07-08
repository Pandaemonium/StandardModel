# Fable-5 call 03: the equivariant-index unifier + the S6 singlet witness + a critical check

You are the most capable theorist on this program. Calls 01 and 02 resolved
the central positivity crux (S1-CC: closure is balanced) and corrected the
C4 double-pinning to a reflection-sectored index. Tonight's kernel landings
(all guard-pinned): the S1-CC engine (`anticonj_odd_pow_trace_zero`,
`anticonj_charpoly_eq`, `half_constraint_rigidity`), the mass-budget
decomposition, the finite Banks-Casher count, the RG-Schur mass-generation
witness (scalar + propagator-general), the chiral det-parity engine, the
S1a leading-closure-energy core, and the aperture-dominance positivity
opener (`aperture_dominance_pos`, your Part C #1 first theorem). The
manuscript is drafted and twice-audited.

Context core: `COLLABORATOR_BRIEF_2026-07-08.md`,
`C4_SECTORED_INDEX_AND_STRATEGY.md`, the manuscript
`Sources/Null_Edge_All_Mass_Manuscript_2026-07-08_v1.md` (provided
verbatim). Read-only repo + graph + Mathlib access.

## Part A (the unifier - main synthesis ask): equivariant index theory on decorated complexes

In call-02 Part C you noted the deeper unifier: "McKean-Singer, the C4
reflection-sectored pinning, and the S1-CC constraint-compatible grading
are all instances of an equivariant index theory on decorated complexes."
Make this precise. Is there a SINGLE finite theorem framework - an
equivariant/graded index on a finite complex with a commuting symmetry
group and a Krein/chiral grading - of which the following are all
corollaries?
- `chiralIndex_eq_graded_dimension` (McKean-Singer index protection),
- the C4 sectored chiral pinning (`dim ker(W∓1)∩V_χ ≥ |ν(χ)|`),
- the S1-CC balanced inertia (anticonjugation => symmetric spectrum),
- the RG-Schur nilpotency-vs-mass dichotomy.
If yes: state the master finite theorem (hypotheses, conclusion), name each
corollary's specialization, and give the cleanest Lean formalization design
(the shared object - a finite graded module with a commuting involution
pair? a Fredholm-free finite Lefschetz index?). If the unification is only
partial, say exactly which instances fit and which do not, and why. This is
the program's candidate organizing theorem - be ambitious but precise.

## Part B (concrete design): the S6 color-singlet mass-budget witness

Your Part C #2: the S6 mass budget should be evaluated on a genuine
color-singlet (strand-monomial) state, not tonight's single-edge witness
(which has closure share exactly 0). Design the smallest concrete witness:
the color fiber is `Λ(C^3)` (the XOR-Fano strand basis; color singlet = the
`Λ^0 ⊕ Λ^3` scalars, or the specific singlet combination), a carrier with
at least two non-commuting transports so `Q_C ≠ 0`, and an explicit singlet
state `ψ`. Give: the concrete operators (matrices), the state, and the
predicted budget fractions `(b_A, b_C, b_T)` with `b_C ≠ 0`, so the
executors can land it as a `decide`/`norm_num` witness. Flag the
convention traps (the XOR-Fano basis, the ΛC^3 vs C⊗O identification, the
Krein `#` vs Hilbert adjoint). Grade each claim.

## Part C (critical check): the one thing that would most strengthen the manuscript

Read the manuscript's thesis and §§3-4 (the trusted kinematic theorem and
the budget decomposition spine). Steelman a skeptical referee: what is the
SINGLE weakest load-bearing link in the claim "all mass is null-edge
disagreement, decomposed into four channels"? Not a grade nitpick - the
deepest conceptual vulnerability. Is it the identification of the carrier
`Q_A` with the trusted `det P` (still abstract, not concrete)? The
finite-to-continuum gap? The claim that the four channels are canonical
rather than chosen? Name it, and give the one theorem or argument that
would most shore it up.

## Output format

- Part A: the master theorem (or the partial-unification map), corollary
  specializations, Lean design. Grade each (T / M-target / MEMO / C).
- Part B: concrete operators + state + predicted `(b_A, b_C, b_T)`,
  convention traps.
- Part C: the single weakest link + the one shoring-up theorem.
