# PhysLean (formerly HepLean): access and integration

**What it is.** PhysLean (renamed from HepLean; Tooby-Smith et al., arXiv:2405.08863)
is an open-source Lean 4 + Mathlib formalization of physics: Standard Model &
beyond (anomaly cancellation, Higgs, CKM, Spin(10), Pati-Salam, two-Higgs-
doublet, right-handed neutrinos), QFT, classical field theory, relativity,
Lorentz group, condensed matter, statistical mechanics, string theory, and
more. **641 `.lean` files, Apache-2.0 licensed.** The Lean library is named
**`Physlib`** (source root `Physlib/`).

Apache-2.0 is permissive: per [`../AGENTS.md`](../AGENTS.md) ("External code and
licensing") we MAY consult it, use it as a comparison target / source of ideas,
and reuse with attribution - but the project style is to **translate the
mathematics and clean-room formalize**, not copy implementation text into
trusted Lean.

## Current access (three tiers, two already live)

### 1. Semantic search - LIVE (`lean-explore` MCP)

The `lean-explore` MCP already indexes PhysLean under package label **`Physlib`**
(offline, GPU-backed). This is the primary discovery tool.

```text
mcp__lean-explore__search_summary  query="Higgs potential Standard Model"  packages=["Physlib"]
  -> StandardModel.HiggsField.Potential, StandardModel.GaugeGroupI, TwoHiggsDoublet..., ...
mcp__lean-explore__get_source_code / get_docstring / get_module / get_dependencies  <id>
```

Use it before formalizing anything SM/QFT/relativity-adjacent: check whether
PhysLean already has the object, read its source, and either cite it or
clean-room port the idea. Note the index may lag PhysLean master; cross-check
against the source clone (tier 2) for anything recent.

### 2. Full-source reference clone - LIVE

A shallow clone lives at **`AgentTasks/external/PhysLean`** (gitignored;
`master`, toolchain v4.31.0). Use `Grep`/`Read` over it for full-text browsing,
convention-checking, and clean-room porting. Refresh with
`git -C AgentTasks/external/PhysLean pull` (or re-clone `--depth 1`).

Directly relevant areas for this project: `Physlib/Relativity` (Lorentz group,
spinors), `Physlib/Particles/StandardModel` and `.../BeyondTheStandardModel/Spin10`
(cross-checks for our octonion/Spin(10) and SM-charge work),
`Physlib/QFT`, `Physlib/ClassicalFieldTheory`.

### 3. Build dependency (import PhysLean in our Lean) - BLOCKED by version pin

**PhysLean master requires Lean/Mathlib v4.31.0; we are hard-pinned to v4.28.0**
(for Aristotle and Sphere-Packing-Lean; see `lakefile.toml`). Adding
`require Physlib` at master would force a single Mathlib version and fail to
resolve. So a direct build integration is **not available without changing our
pin**, which the lakefile explicitly forbids.

Options if a genuine `import Physlib.*` dependency is ever needed:

- **(a) Pin a v4.28.0-era PhysLean commit** as an *optional* require behind a
  separate lake root (the pattern the lakefile already uses for `PhysicsSMSPL`).
  PhysLean tracked Mathlib v4.28.0 around mid-2025; `git log` an unshallowed
  clone for the commit whose `lean-toolchain` is `v4.28.0`, and
  `require Physlib git=... rev=<that-commit>`. Cost: that older PhysLean lacks
  recent additions, and a second Mathlib-consistent require is fiddly.
- **(b) Bump the whole stack to v4.31.0.** NOT recommended - breaks the
  Aristotle + SpherePacking pin; only do it if Mathlib, SpherePacking, and the
  Aristotle workflow all rebuild cleanly under v4.31.0 (the lakefile's rule).
- **(c) Don't build-integrate.** Recommended default: tiers 1+2 give full
  read/discovery/clean-room access, which is the project's preferred mode anyway
  (translate math, don't copy). Only escalate to (a) for a specific,
  load-bearing import that cannot be clean-room reproduced.

## What's genuinely useful for us (2026-07-08 survey)

We do **not** import PhysLean in any `PhysicsSM/**` Lean - it appears only as a
cited prior-art / tooling mention and clean-room design reference. A survey of
the clone found three areas worth *consulting and convention-cross-checking*
(not importing - version-pinned - and, per clean-room policy, port ideas not
text):

1. **Weyl-spinor / SL(2,C) metric calculus - highest value (our §3 layer).**
   `Physlib/Relativity/Tensors/ComplexTensor/Weyl/` (`leftMetric`, `rightMetric`,
   `dualLeftMetric`, `metricRaw`, contraction, modules) and `Physlib/Relativity/SL2C`
   are a mature, convention-fixed formalization of exactly the objects behind our
   trusted `Spinor/PluckerMass` (`wedge` = the SL(2) invariant, `det P = sum
   |psi_i ^ psi_j|^2`). Use it to (a) **cross-check our spinor conventions**
   against a peer formalization, (b) strengthen §3's "this is classical
   spinor-helicity" claim by pointing at an independent Lean formalization, and
   (c) borrow ideas for a cleaner general-`n` Plücker statement (see the landed
   `MassMonogamy`).
2. **Pauli matrices + Dirac/Clifford algebra - high value (the carrier).**
   `Physlib/Relativity/PauliMatrices/` (`Relations`, `CliffordAlgebra`,
   `SelfAdjoint`) and `Physlib/Relativity/CliffordAlgebra.lean` (`diracAlgebra`,
   `diracForm`, `ofCliffordAlgebra`, Pauli contraction/trace relations). Our
   carrier's Clifford soldering and the Cl(4) escape construction use Pauli/gamma
   matrices directly - cross-check our metric-signature / Hermiticity conventions
   and clean-room-adapt reusable Pauli identities.
3. **SM/BSM anomaly cancellation + hypercharge, and Spin(10) - if we make
   charge claims.** `Physlib/Particles/StandardModel/AnomalyCancellation`,
   `.../BeyondTheStandardModel/RHN/AnomalyCancellation/.../HyperCharge.lean`, and
   `.../BeyondTheStandardModel/Spin10` (PhysLean's flagship results). Relevant to
   any hypercharge/anomaly statement (the §2 Part-I strand/charge picture) and to
   the octonion / Spin(10) stabilizer thread. Cite + cross-check.

**Recommended immediate use:** whenever we touch spinors, Clifford/Pauli, or SM
charges, run a `lean-explore packages=["Physlib"]` query first and cross-check
conventions against the clone - and cite PhysLean's Weyl/spinor formalization in
§3 to reinforce the "classical kinematics, ours is the packaging" honesty.

### Deeper survey (2026-07-08): more to mine, and confirmed gaps

4. **Second quantization / Wick framework - highest new value (our §9 boundary
   and the many-body roadmap).** `Physlib/QFT/PerturbationTheory/` is a full
   machine-verified field-theory layer: `CreateAnnihilate`, `FieldOpFreeAlgebra`
   (normal/time ordering, super-commute, grading), `WickAlgebra`,
   `WickContraction`, and proved `wicks_theorem` / `static_wick_theorem` /
   `wicks_theorem_normal_order`. This is *exactly* the Fock/creation-annihilation
   layer our manuscript §9 declares out of scope. Two uses: (a) cite it now in
   §9 as the peer machine-verified second-quantized framework (strengthens the
   honesty of "we are deliberately first-quantized"); (b) it is the concrete
   target *if* the program ever pursues second quantization - the many-body layer
   where a genuine hadron mass and condensate would live (Fable/Pro roadmap).
5. **Minkowski / indefinite metric - convention cross-check for the Krein
   carrier.** `Physlib/Relativity/MinkowskiMatrix.lean` and
   `Tensors/RealTensor/Vector/MinkowskiProduct.lean` formalize the indefinite
   spacetime metric. Cross-check our Krein fundamental symmetry `J` / signature
   conventions against it when the carrier metric is pinned.
6. **Reusable math tooling.** `Physlib/Mathematics/InnerProductSpace` (adjacent
   to `sector_ground_mass` / Rayleigh-Ritz), `Mathematics/VariationalCalculus`
   and `ClassicalFieldTheory/Local/Variation` (any action / variational-principle
   work; the mass functional is a Rayleigh quotient), `Mathematics/KroneckerDelta`
   (the S6 Kronecker-product witness). Consult opportunistically.
7. **Dynamics stack (the biggest structural borrow) - see
   `AgentTasks/overnight-allmass-run-2026-07-08/DYNAMICS_GROUNDWORK.md`.** For
   developing the program's dynamics + simulations, clean-room-borrow PhysLean's
   `Mathematics/VariationalCalculus` (`HasVarGradient`, Euler-Lagrange
   fundamental theorem), `ClassicalMechanics` (`lagrangian`, `hamiltonian`,
   `EulerLagrange`, `HamiltonsEquations`, conservation theorems), and
   `StatisticalMechanics/CanonicalEnsemble` (`partitionFunction`,
   `helmholtzFreeEnergy` - the thermodynamic-limit route to the §9 condensate
   question). This gives the carrier the *action + equation-of-motion +
   conservation + ensemble* structure it currently lacks. Clean-room finite
   seeds now exist in `PhysicsSM/Draft/NullEdge/Carrier/FiniteCarrierAction.lean`
   (D1 multiplier action/EOM),
   `PhysicsSM/Draft/NullEdge/Carrier/FiniteUnitaryEvolution.lean` (D2/D3
   isometric evolution and conserved energy observables),
   `PhysicsSM/Draft/NullEdge/Carrier/FiniteRGFlow.lean` (D4 finite flow
   invariants / monotone observables), and
   `PhysicsSM/Draft/NullEdge/Carrier/FiniteCanonicalEnsemble.lean` (D5 finite
   partition function/probability normalization).

**Confirmed ABSENT (reassuring for novelty - PhysLean does not pre-empt these):**
Wilson loops / lattice gauge theory (its QFT is continuum perturbation theory);
a Dirac *operator* as a named object (it has the Dirac *algebra*/matrices only);
a Grassmannian / Plücker-mass formalization (only anomaly-solution "planes");
and a positive-energy / ADM / Witten theorem. So §6 (closure/Wilson), the carrier
Dirac operator, the Plücker-mass packaging (§3, `MassMonogamy`), and F4 (finite
Witten positive-mass) are genuinely ours - consistent with the literature review.

## Optional: full-text meaning search alongside our own docs

To search PhysLean *by meaning at the chunk level* alongside this repo's docs
(not just declaration summaries), ingest its `.lean`/docs into the Neo4j
`ne_chunk`/doc index via `Scripts/lit/neo4j_doc_search.py` / `lit_ingest.py`
(Neo4j must be up; the MCP was down in the 2026-07-08 session). This is additive
and only worth doing if tier-1 declaration search proves too coarse.

## Recommendation

For "fully accessible" in this project's sense - **discovery + reference +
clean-room porting - you now have it** (tiers 1+2). Build-time `import` is the
only piece gated, and it is gated by the deliberate v4.28.0 pin, not by tooling.
Keep the pin; use semantic search + the source clone; escalate to a
v4.28.0-era optional require only for a specific unavoidable import.
