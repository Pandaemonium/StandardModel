# Q4. A selection theorem for the Standard Model's discrete data

Aim: turn "the SM gauge group and representation content are inputs" into "they
are the index/commutant data of a small canonical complex" - or prove that no
such selection is possible and identify exactly what extra principle is needed.

## Setup / assets

Our kernel-checked assets relevant here: the color-commutant theorem (the
commutant of the color action on the triplet is the scalars - only color-blind
scalar masses are color-exact); an octonion algebra formalization (XOR-labeled
Fano basis, convention-bridged) built for the Furey-style program in which one
generation of SM fermions sits inside (left-multiplication operators on)
C tensor O, with SU(3) as the stabilizer structure; the index trinity of the
carrier - chiral index ind (protected massless count, KERNEL), Pontryagin index
kappa (ghost/gauge directions, KERNEL witness), and the Weitzenboeck inertia
(which mass channels are active). External anchor: Connes' finite spectral triple
with algebra C + H + M_3(C) reproducing SM representation content and the Higgs
as inner fluctuation.

## The questions

1. THE TARGET TRIPLE. For ONE SM generation with unbroken SU(3)xU(1)_em (or
   better, the full SU(3)xSU(2)xU(1) with hypercharges), what would the triple
   (ind, kappa, inertia) plus the transport commutant algebra of a null-edge
   complex have to be, exactly? Produce the finite checklist: dimensions,
   gradings, commutants, index values, anomaly-shaped constraints (which finite
   identity plays the role of anomaly cancellation - is it an index-sum rule on
   the complex?).
2. MINIMALITY. What is the SMALLEST decorated 2-complex (edge count, vertex
   count, decoration algebra) that can realize that checklist? Is the answer
   plausibly unique at minimal size (a selection theorem: "the minimal
   anomaly-free chiral complex with a nonabelian commutant IS one SM
   generation")? Sketch either the uniqueness argument or the degeneracy space.
3. OCTONIONS OR NOT. Does the C tensor O route (Furey; Dixon; Todorov-Dubois-
   Violette; Boyle) and the Connes route (C+H+M_3(C)) land on the SAME minimal
   complex from different sides - i.e. is there a dictionary between division-
   algebra decorations of null edges and finite spectral-triple data? If they
   differ, which disagreement is testable inside our finite framework?
4. HYPERCHARGE. In our frame hypercharge should be a linear functional on some
   finite lattice (cycle space of the complex? grading charges?). Derive the
   hypercharge assignments of one generation from a stated combinatorial
   principle, or show why no local combinatorial principle can fix them
   (tracking the known Z_6 structure of the SM charge lattice).
5. FORMALIZATION LADDER. The 3 first Lean-able statements toward the selection
   theorem, each finite, each with displayed hypotheses - e.g. "the commutant of
   [decoration] on [complex] is isomorphic to su(3)+u(1)", "the chiral index of
   [complex] equals [SM value] and is deformation-invariant".
6. LITERATURE: exact citations (Furey; Dixon; Connes-Chamseddine; Boyle-Farnsworth;
   Todorov; Krasnov's spinor-SM papers; Baez-Huerta division-algebra reviews).

## Success criterion

The checklist (question 1) in full precision plus EITHER a candidate minimal
complex with its data computed, OR a proof-shaped argument that minimality cannot
select the SM without an added principle - named. Kill-condition: if hypercharge
cannot be derived from any local combinatorial principle, say so and specify the
smallest nonlocal one that works.
