# LANDING AUDIT REPORT -- Codex audit 01

Operational locality, finite SSB, and generated scale.

Independent semantic audit. No files were edited and no full build was run; the
five modules were read line by line. Findings are grouped per module, one
subsection per public declaration, and each declaration is assessed on the six
requested axes:

1. type paraphrase;
2. vacuity / hollow telescoping / false shape / docstring overreach;
3. hidden assumptions, zero-dimensional edge cases, normalization or
   tensor-factorization inputs;
4. whether the explicit witness/control genuinely excludes the advertised
   degenerate mode;
5. strongest supported vs strongest unsupported manuscript sentence;
6. highest-value composition theorem to the null-information carrier, with an
   exact statement shape and a kill condition.

Global note on the axiom guard: `OvernightTheoryAxiomGuard.lean` pins eight of
these declarations to `[propext, Classical.choice, Quot.sound]` via
`#guard_msgs` + `#print axioms`. That set is inside the allowed kernel-axiom
budget, so nothing smuggles in `sorry`, custom `axiom`, or `native_decide`.
Caveat: the guard covers a strict subset (the eight "landing" theorems); several
public helpers (`runningInv_cocycle`, `runningInv_pos`, `runningGSq_pos`,
`resetK_tracePreserving`, `reset_changes_joint_state`, `regional_generation`,
`regional_isotony`, `separated_generators_commute`, `left_qubit_noncommutative`,
`commuting_symmetry_preserves_simple_line`, `vecNormSq_mulVec_unitary`) are not
individually pinned. They are used by the pinned theorems or are structurally
identical in axiom footprint, so this is a documentation gap, not a soundness
gap.

--------------------------------------------------------------------------------

## Module 1 -- FiniteNoSignaling.lean

Namespace `PhysicsSM.Draft.NullEdge.FiniteNoSignaling`.

Overall shape: a local completely-positive map on register B, written in Kraus
entry form, leaves the reduced matrix on register A unchanged, plus a concrete
reset channel as nondegenerate control. This is the "null-information carrier"
lane most directly labelled no-signaling.

### 1.1 `partialTraceB` (def)

1. Reduced matrix on A: `(rho -> fun a a' => sum_b rho (a,b) (a',b))`, the
   partial trace over the second finite factor `Fin m`.
2. Not a theorem; a definition, so no vacuity. It is the literal diagonal-in-B
   sum. No overreach: the docstring says exactly this.
3. Zero-dim edges: if `m = 0` the sum is empty and every marginal entry is `0`
   (the zero operator, not a normalized state); if `n = 0` the output lives on
   `Matrix (Fin 0)` and is trivially unique. `rho` is an arbitrary matrix, not
   constrained to be Hermitian / PSD / unit-trace -- this is the first place the
   "unrestricted matrix input" generality enters.
4. n/a (definition).
5. Supports: "the reduced description on A is the B-diagonal contraction of the
   joint matrix." Does not support: "this is the partial trace of a density
   operator" (no positivity/trace-1 is imposed here).
6. See 1.4.

### 1.2 `applyLocalKrausB` (def)

1. The local channel `rho -> sum_k (I (x) K_k) rho (I (x) K_k)^dagger` in entry
   form: `sum_k sum_c sum_d K_k(x2,c) * rho((x1,c),(y1,d)) * conj K_k(y2,d)`.
   Acts only through the B-index; the A-indices `x1,y1` pass through untouched.
2. Definition; faithful to the "local Kraus operation on B" description. The
   channel form is correct (Kraus sandwich, identity on A).
3. `K` is an arbitrary family `Fin r -> Matrix (Fin m) (Fin m)`; trace
   preservation is NOT baked into the definition (it is a separate hypothesis on
   the theorem). No CP/positivity constraint on the individual `K_k` beyond
   their appearing as `K` ... `star K`. Zero-dim: `r = 0` gives the zero map;
   `m = 0` gives the zero matrix.
4. n/a.
5. Supports: "a finite Kraus family acting on B alone." Does not support:
   "a physically admissible channel" until trace preservation is added.
6. See 1.4.

### 1.3 `IsTracePreserving` (def / Prop)

1. Entry-form statement of `sum_k K_k^dagger K_k = I`:
   `forall c d, sum_k sum_b conj(K_k(b,d)) * K_k(b,c) = (if c = d then 1 else 0)`.
2. Correct TP/unitality condition for the Kraus family (Kronecker on the right).
   No vacuity: it is a genuine constraint on `K`.
3. Zero-dim: if `m = 0` the predicate quantifies over empty `c d` and is
   vacuously true -- any (empty) family is "trace preserving". This is the
   correct degenerate reading, but a manuscript should not cite the `m = 0`
   instance as content. Normalization input: this predicate IS the only
   normalization imposed; nothing forces the `K_k` to be a resolution of a valid
   instrument beyond this quadratic identity.
4. n/a.
5. Supports: "the family satisfies the completeness relation." Does not support:
   "the family is unital" (that is `sum K K^dagger = I`, the dual, not stated) or
   "each K_k is a contraction."
6. See 1.4.

### 1.4 `partialTraceB_applyLocalKrausB` (theorem) -- MAIN PAYLOAD

1. For any finite `K` with `IsTracePreserving K` and any joint matrix `rho`,
   `partialTraceB (applyLocalKrausB K rho) = partialTraceB rho`. I.e. a
   trace-preserving local operation on B leaves the A-marginal exactly fixed:
   operational no-signaling A <- B.
2. Not vacuous: the hypothesis `IsTracePreserving K` is satisfiable (proved by
   1.6) and the conclusion is a nontrivial equality of A-matrices; the reset
   witness (1.9) shows the joint state genuinely moves while the marginal does
   not, so the theorem is not "0 = 0". No hollow telescoping: the Fubini
   reindexing (`h_fubini`) does real work collapsing the `k,b` sums against the
   completeness relation. False-shape check passes: the direction is the
   physical one (marginal on the OTHER register is protected). Docstring
   ("leaves the reduced matrix on register A exactly unchanged") matches the
   type exactly.
3. **Key generality flag (as requested).** `rho` ranges over ALL complex
   matrices on `Fin n x Fin m`; there is no Hermitian / PSD / unit-trace / valid
   density-matrix hypothesis. This makes the theorem a pure multilinear-algebra
   identity -- algebraically STRONGER (it holds for non-states, complex "quasi
   densities", unnormalized inputs) but physically LESS SPECIFIC: it is not
   phrased over the state space where no-signaling is a physics statement.
   Similarly `K` is unrestricted apart from the single quadratic completeness
   relation, so complete positivity is never used and never asserted. Zero-dim:
   holds trivially for `n = 0`, `m = 0`, or `r = 0` (empty sums), so those
   instances carry no content. No normalization of `rho` is consumed; the only
   normalization is the `K` completeness relation.
4. Control is genuine -- see 1.9 (`reset_no_signaling_witness`), which certifies
   that some TP local channel moves the joint matrix yet fixes the marginal, so
   the theorem is not vacuously "the map did nothing".
5. Strongest supported manuscript sentence: "For a supplied finite tensor
   factorization H_A (x) H_B, every trace-preserving Kraus operation localized on
   B leaves the A-reduced matrix identically unchanged; an explicit
   state-altering reset channel confirms the invariance is not trivial."
   Strongest sentence it does NOT support: "No local operation can transmit
   information between causally separated regions" -- there is no spacetime,
   no causal separation, no restriction to physical states, no CP requirement,
   and the factorization is assumed rather than derived from separation.
6. Highest-value composition to the carrier: connect B-locality to the carrier
   channel assignment `Z : NullHist -> channels`. Proposed
   `carrier_local_no_signaling`:
   shape -- given a carrier region splitting `A(R) = A(R_L) (x) A(R_R)` induced by
   a null-history cut, and a carrier channel `Phi` supported on `R_R` with
   `IsTracePreserving` Kraus data, then `partialTrace_{R_R} (Phi rho) =
   partialTrace_{R_R} rho` for every carrier state `rho`.
   Kill condition: exhibit a carrier cut whose induced algebra map is NOT a
   tensor factorization (the two subalgebras fail `separated_regions_commute`
   from Module 2), making `partialTraceB` ill-defined as a marginal -- i.e. the
   composition dies exactly when graph separation fails to produce genuine
   tensor factors.

### 1.5 `resetK` (def)

1. One-qubit reset Kraus pair `|0><0|` and `|0><1|` as
   `![!![1,0;0,0], !![0,1;0,0]]`.
2. Definition; faithful.
3. Fixed dimension `m = 2`, `r = 2`. No hidden assumption.
4. n/a.
5/6. Feeds 1.6-1.9.

### 1.6 `resetK_tracePreserving` (theorem)

1. `IsTracePreserving resetK`: the reset pair satisfies `sum_k K_k^dagger K_k = I`.
2. True and nonvacuous (`m = 2` is a real index set). No overreach.
3. Pure `decide`/`simp` finite check; no hidden inputs.
4. n/a.
5. Supports "the reset instrument is a legitimate channel." Not: "the reset is
   unital" (it is not; `sum K K^dagger != I` for reset, and this is not claimed).
6. Supplies the nondegenerate control instance for the 1.4 composition.

### 1.7 `rhoHiddenOne` (def)

1. Joint input on `Fin 1 x Fin 2` equal to `|1><1|` on B (A trivial):
   `if x2 = 1 and y2 = 1 then 1 else 0`.
2. Definition; faithful. This IS a valid pure state (rank-one, unit trace),
   which is what makes the control physically meaningful even though 1.4 does not
   require it.
3. A-factor is `Fin 1` (trivial region A). Genuine hidden simplification: the
   "remote" region is one-dimensional, so "marginal fixed" here is the weakest
   nontrivial instance.
4. n/a.
5/6. Feeds the witness.

### 1.8 `reset_changes_joint_state` (theorem)

1. `applyLocalKrausB resetK rhoHiddenOne != rhoHiddenOne`: the local reset really
   changes the joint matrix.
2. Genuine inequality (checked at entry `(0,1),(0,1)`), not vacuous. This is the
   non-triviality certificate for the control.
3. Fixed small dimensions; no hidden assumption.
4. This is precisely the exclusion of the degenerate "channel = identity" mode:
   it proves the map is not the identity on the joint state.
5. Supports "the local operation is nontrivial on the joint description."
6. Half of the composition control.

### 1.9 `reset_no_signaling_witness` (theorem)

1. Conjunction: `applyLocalKrausB resetK rhoHiddenOne != rhoHiddenOne` AND its
   A-marginal equals that of `rhoHiddenOne`. I.e. a single channel that moves the
   joint state yet fixes the remote marginal.
2. Nonvacuous and correctly shaped: this is the operational no-signaling
   headline (change here, no change there). No telescoping -- second conjunct is
   the 1.4 instance, first is 1.8.
3. Inherits `Fin 1` remote region (weakest nontrivial A) and the concrete B
   reset. No general-state claim.
4. Yes -- this is the decisive witness that excludes the degenerate reading
   "the marginal is fixed only because nothing happened."
5. Strongest supported: "There exists a nontrivial trace-preserving local
   operation that provably alters the joint state while leaving the remote
   marginal exactly invariant." Strongest NOT supported: "This demonstrates
   relativistic causality / spacelike no-signaling" (no metric, no light cone,
   A-region is one-dimensional).
6. Use as the certified nondegenerate instance in `carrier_local_no_signaling`;
   kill condition as in 1.4.

--------------------------------------------------------------------------------

## Module 2 -- TwoRegionTensorMicrocausality.lean

Namespace `PhysicsSM.Draft.NullEdge.TwoRegionTensorMicrocausality`.

Overall shape: two finite matrix algebras embedded as the left/right factors of
`A (x)[R] B`; separated observables commute, the two factors generate the whole
algebra, and a qubit witness shows each factor is internally noncommutative.

### 2.1 `leftAlgebra` / `rightAlgebra` (defs)

1. `leftAlgebra = range includeLeft`, `rightAlgebra = range includeRight`: the
   subalgebras `A (x) 1` and `1 (x) B`.
2. Definitions; faithful.
3. General `[CommSemiring R] [Semiring A] [Semiring B] [Algebra R A] [Algebra R B]`.
   **Tensor-factorization input flag:** the factorization is SUPPLIED as the
   ambient `A (x)[R] B`; nothing derives it from region/graph separation. Zero
   edge: if `A` or `B` is the trivial ring the corresponding subalgebra collapses
   to scalars, but statements below still hold.
4. n/a.
5. Supports "the two regional algebras are the images of the canonical factor
   inclusions." Not: "these are the observable algebras of spatially separated
   spacetime regions."
6. See 2.5.

### 2.2 `separated_generators_commute` (theorem)

1. For elementary `a in A`, `b in B`, `includeLeft a` commutes with
   `includeRight b` in `A (x) B` (`(a (x) 1)(1 (x) b) = (1 (x) b)(a (x) 1)`).
2. True, nonvacuous, correctly shaped. No overreach.
3. Holds for all semirings; the commutation is a tautology of the tensor
   multiplication rule (`tmul_mul_tmul` with `a*1 = 1*a` on scalars) -- i.e. it
   is BUILT IN by the factorization, not emergent. This is the central "two-factor
   commutation vs emergent locality" caution: it is the former.
4. n/a.
5. Supports "cross-factor generators commute by construction."
6. Feeds 2.3.

### 2.3 `separated_regions_commute` (theorem) -- PINNED

1. Every `x in leftAlgebra` commutes with every `y in rightAlgebra`.
2. Nonvacuous (both ranges are nonempty), correct shape (Einstein/microcausality
   rung for the supplied factorization). No telescoping beyond lifting 2.2 along
   the range membership.
3. **Emergent-locality caution (as requested):** this is exact commutation of
   two supplied tensor factors. It is NOT derived from any separation predicate;
   calling it "microcausality" is justified only in the tautological
   "commuting-subalgebras" sense. Holds for all semirings incl. degenerate rings.
4. Paired control is 2.7 (`left_qubit_noncommutative`) which shows the local
   algebra is genuinely noncommutative, so "everything commutes with everything"
   is excluded -- the commutation is specifically cross-factor.
5. Strongest supported: "For a supplied finite tensor factorization, the two
   factor subalgebras mutually commute while each remains internally
   noncommutative." Strongest NOT supported: "Microcausality is derived: spacelike
   separation implies commuting observables" (no spacetime, no separation
   hypothesis; the tensor split is assumed).
6. See 2.5 / 2.8.

### 2.4 `regional_isotony` (theorem)

1. `leftAlgebra <= top AND rightAlgebra <= top`.
2. TRUE but essentially trivial (`le_top` twice). Borderline hollow: it restates
   that subalgebras sit inside the whole algebra. Not false, not vacuous, but the
   manuscript should not cite "isotony" as content -- there is no region poset,
   only the two-element `{L,R} <= whole` inclusion.
3. No assumptions beyond the instances.
4. n/a.
5. Supports "each factor subalgebra embeds in the joint algebra." Not: "isotony
   over a net of regions" (there is no net).
6. Minor; subsumed by 2.5.

### 2.5 `regional_generation` (theorem)

1. `leftAlgebra sup rightAlgebra = top`: the two factors jointly generate the
   entire tensor-product algebra.
2. True and substantive (this is the nontrivial half of "the two regions are a
   complete local decomposition"). Correct shape; proof lifts
   `TensorProduct.map_id`/`range_id`.
3. Holds generally. This is the genuine "completeness of the local net" content
   of the module (more than isotony/commutation, which are near-tautological).
4. n/a.
5. Strongest supported: "The two regional factor algebras generate the full joint
   observable algebra." Not: "the joint algebra is the unique local completion of
   the regional data" (uniqueness/split property not addressed).
6. Highest-value composition for this module: bind the factorization to the
   carrier region algebra `A(R)`. Proposed `carrier_region_split`:
   shape -- for a carrier null-history cut `R = R_L cup R_R`, the induced maps
   give `A(R) = A(R_L) (x)[R] A(R_R)` with `leftAlgebra sup rightAlgebra = top`
   and `separated_regions_commute`, AND (bridge to Module 1) `partialTrace_{R_R}`
   is well defined and no-signaling on `A(R_L)`.
   Kill condition: produce a carrier cut for which the natural comparison map
   `A(R_L) (x) A(R_R) -> A(R)` is not an isomorphism (fails surjectivity =
   generation, or fails injectivity = independence). That is exactly the
   unproven step "graph separation supplies tensor factors"; if it fails, both
   the microcausality and the no-signaling composition collapse.

### 2.6 `sigmaX` / `sigmaZ` (defs)

1. Pauli X and Z as explicit `Fin 2` matrices.
2. Definitions; faithful.
3. Fixed `C`, dimension 2.
4/5/6. Feed 2.7-2.8.

### 2.7 `left_qubit_noncommutative` (theorem)

1. `not Commute (includeLeft sigmaX) (includeLeft sigmaZ)` in
   `M2(C) (x) M2(C)`: two observables in the SAME (left) region fail to commute.
2. Genuine negation (reduced via `includeLeft_injective` to `[X,Z] != 0`),
   nonvacuous. Correctly excludes the "abelian factor" degenerate mode.
3. Uses `includeLeft_injective`, which needs `algebraMap C M2(C)` injective
   (supplied via `FaithfulSMul`). No hidden gap. Fixed qubit dimension.
4. This is the decisive control: it proves the local algebra is not commutative,
   so 2.3 is not the trivial "abelian everything" statement.
5. Supports "the local region algebra is genuinely noncommutative." Not: "the
   region carries the full observable content of a qubit field."
6. Supplies the nondegeneracy certificate for `carrier_region_split`.

### 2.8 `two_qubit_local_net_verdict` (theorem) -- PINNED

1. Conjunction: left factor noncommutative AND cross-factor total commutativity,
   for the `M2(C) (x) M2(C)` instance.
2. Nonvacuous, correctly shaped as the "compact verdict." No telescoping issues;
   it just pairs 2.7 and 2.3.
3. Concrete qubit instance; inherits the "supplied factorization" caveat.
4. Yes -- the pairing is exactly what excludes both degenerate modes at once
   (everything-commutes and nothing-commutes).
5. Strongest supported: "A concrete finite two-region model exhibits internal
   noncommutativity together with exact cross-region commutativity." Not:
   "This is a Haag-Kastler net satisfying microcausality over spacetime."
6. As 2.5.

--------------------------------------------------------------------------------

## Module 3 -- FiniteSSBDegeneracyNoGo.lean

Namespace `PhysicsSM.Draft.NullEdge.FiniteSSBDegeneracyNoGo`.

Overall shape: a no-go (nondegenerate/simple eigenstate is symmetry-invariant as
a density matrix) plus a degenerate witness where a commuting unitary moves one
ground representative to a distinct one.

### 3.1 `vecNormSq` / `pureDensity` (defs)

1. `vecNormSq psi = sum_i |psi_i|^2`; `pureDensity psi = psi_i * conj(psi_j)`
   (rank-one, unnormalized).
2. Definitions; faithful.
3. `pureDensity` is unnormalized (trace = vecNormSq, not forced to 1). Zero-dim:
   `n = 0` gives `vecNormSq = 0` and the empty density.
4. n/a.
5/6. Feed the theorems.

### 3.2 `IsSimpleEigenpair` (def / Prop)

1. `psi != 0`, `H psi = E psi`, and every `phi` with `H phi = E phi` is a scalar
   multiple of `psi` -- i.e. the E-eigenspace is the one-dimensional line `C psi`
   (algebraic simplicity/nondegeneracy).
2. Correct, nonvacuous predicate. This is exactly "nondegenerate eigenvalue."
3. **Normalization input:** simplicity is stated over the whole vector space (no
   inner-product/self-adjointness of `H` needed), a clean choice. Zero-dim:
   requires `psi != 0`, impossible for `n = 0`, so the predicate is unsatisfiable
   there (no false content).
4. n/a.
5. Supports "the chosen eigenvalue is geometrically simple." Not: "H is
   self-adjoint / the eigenvalue is real."
6. See 3.6.

### 3.3 `commuting_symmetry_preserves_simple_line` (theorem)

1. If `H U = U H` and `psi` is a simple E-eigenpair, then `U psi = c psi` for
   some scalar `c`: a commuting symmetry maps the simple line to itself.
2. True, nonvacuous, correct shape. Clean use of simplicity: `U psi` is again an
   E-eigenvector, hence proportional.
3. No unitarity needed here (only commutation + simplicity). General `n`.
4. n/a.
5. Supports "a commuting symmetry stabilizes a nondegenerate eigenline." Not:
   "the symmetry acts trivially" (`c` may be any scalar).
6. Feeds 3.5.

### 3.4 `vecNormSq_mulVec_unitary` (theorem)

1. If `U^dagger U = 1` then `vecNormSq (U psi) = vecNormSq psi`: unitaries are
   norm-preserving.
2. True, nonvacuous, correct.
3. Uses only left-isometry `U^dagger U = 1` (not full two-sided unitarity), which
   is the correct minimal hypothesis for norm preservation. General `n`.
4. n/a.
5. Supports "isometries preserve the squared norm." Fine.
6. Feeds 3.5.

### 3.5 `simple_eigenstate_density_invariant` (theorem) -- PINNED, MAIN NO-GO

1. For a normalized (`vecNormSq psi = 1`) simple E-eigenstate `psi`, a commuting
   left-isometry `U` (`U^dagger U = 1`, `H U = U H`) satisfies
   `pureDensity (U psi) = pureDensity psi`: the pure state is symmetry-invariant.
   Physics reading: no spontaneous breaking on a nondegenerate ground state.
2. Nonvacuous (hypotheses jointly satisfiable, e.g. `psi` an eigenvector,
   `U = 1`), correctly shaped (the phase `c` with `|c| = 1` cancels in the
   rank-one product). No hollow telescoping. Docstring matches: "normalized
   simple eigenstate has a symmetry-invariant pure density matrix."
3. Requires normalization `vecNormSq psi = 1` (used to force `|c| = 1`) and the
   left-isometry condition. **Necessary-vs-sufficient flag (as requested):** this
   theorem is the contrapositive backbone -- simplicity (nondegeneracy) forbids
   breaking, hence *degeneracy is NECESSARY for breaking*. It says nothing about
   sufficiency. Zero-dim: unsatisfiable for `n = 0` (no nonzero normalized psi).
4. Control is 3.10: it shows a degenerate H where the conclusion's mechanism
   fails (line not preserved), confirming the necessity direction is tight.
5. Strongest supported: "On a finite system, a normalized nondegenerate
   eigenstate has a pure density matrix invariant under every commuting unitary
   symmetry; degeneracy is therefore necessary for any symmetry to break the
   ground state." Strongest NOT supported: "Finite degeneracy causes / is
   sufficient for spontaneous symmetry breaking" -- the theorem only blocks
   breaking in the simple case; sufficiency (an actual selected non-invariant
   ground state, order parameter, thermodynamic limit) is neither stated nor
   implied.
6. Highest-value composition to the carrier: link to the carrier state `omega`
   and its symmetry group acting on `A(R)`. Proposed
   `carrier_nondegenerate_no_ssb`:
   shape -- if the carrier ground sector `ker Q / im Q` restricted to `J > 0` is
   one-dimensional (simple) and `U` is a carrier symmetry commuting with the
   carrier Dirac/cost operator `D`, then the carrier ground density is
   `U`-invariant.
   Kill condition: exhibit a carrier symmetry `U` commuting with `D` and a
   ground representative moved off its line WITHOUT the physical ground sector
   being degenerate -- i.e. show the physical Hilbert space
   `(ker Q/im Q)_{J>0}` is simple yet breaks. If found, the no-go is falsified
   at the carrier level; conversely if every such break forces sector
   degeneracy, the necessity claim lifts to the carrier.

### 3.6-3.9 `Hdeg`, `Uswap`, `e0`, `e1` (defs)

1. Degenerate Hamiltonian `Hdeg = 0` on `Fin 2`; swap `Uswap = !![0,1;1,0]`;
   basis vectors `e0 = (1,0)`, `e1 = (0,1)`.
2. Definitions; faithful. `Hdeg = 0` is maximally degenerate (every vector is a
   0-eigenvector), the sharpest possible degenerate fixture.
3. Fixed qubit dimension. `Uswap` is a genuine nonidentity unitary.
4. n/a.
5/6. Feed 3.10.

### 3.10 `degenerate_symmetry_breaking_witness` (theorem) -- PINNED, CONTROL

1. Six-fold conjunction: `Hdeg` commutes with `Uswap`; `Uswap` is unitary
   (`U^dagger U = 1`); `e0`, `e1` are both ground states of `Hdeg`;
   `Uswap e0 = e1`; and `not exists c, Uswap e0 = c * e0` -- the swap moves the
   ground representative `e0` off its own line to a distinct representative.
2. Nonvacuous, correctly shaped as the negation of the no-go's line-preservation
   in the degenerate case. Note the type as written proves the LINE is not
   preserved (`not exists c, U e0 = c e0`); it does not literally assert
   `pureDensity (U e0) != pureDensity e0`, though that also holds
   (`diag(1,0) != diag(0,1)`). Minor docstring-vs-type gap: "move ... to a
   distinct representative" is exactly what `Uswap e0 = e1` + the non-scalar
   clause give, so no real overreach.
3. `Hdeg = 0` means `e0` is NOT a simple eigenpair (2-dim eigenspace), so the
   no-go's hypothesis genuinely fails -- the control is on the correct side of
   the dichotomy. Fixed qubit.
4. Yes: this genuinely excludes the "commuting symmetry can only rephase" mode by
   producing a commuting unitary that permutes distinct ground representatives.
   It certifies that the no-go's simplicity hypothesis is load-bearing.
5. Strongest supported: "In a degenerate finite ground space, a symmetry
   commuting with the Hamiltonian can carry one ground representative to a
   genuinely distinct one." Strongest NOT supported: "This exhibits spontaneous
   symmetry breaking" -- there is no selected state, no order parameter, no
   limit; it only shows degeneracy PERMITS a non-invariant representative
   (possibility, not the physical phenomenon).
6. Serves as the kill-condition instance for `carrier_nondegenerate_no_ssb`.

--------------------------------------------------------------------------------

## Module 4 -- OneLoopDimensionalTransmutation.lean

Namespace `PhysicsSM.Draft.NullEdge.OneLoopDimensionalTransmutation`.

Overall shape: from a supplied one-loop inverse-coupling law
`1/g^2 = 2 b log(mu/Lambda)`, prove positivity on the AF branch, an additive RG
cocycle, and reconstruction of `Lambda`, with an `(b,Lambda,mu) = (1/2,1,e)`
fixture.

### 4.1 `runningInv` (def)

1. `runningInv b Lambda mu = 2 b log(mu/Lambda)` -- inverse squared coupling.
2. Definition; faithful.
3. **Circularity flag (as requested):** `Lambda` appears explicitly inside the
   running law. Everything downstream that "reconstructs `Lambda`" is inverting
   this definition. Real-log conventions: `log` of nonpositive argument is `0`,
   so off-branch values are silently degenerate.
4. n/a.
5/6. See 4.7.

### 4.2 `runningGSq` (def)

1. `runningGSq = 1 / runningInv` -- squared coupling.
2. Definition; faithful.
3. Junk value at `runningInv = 0` (division by zero = 0 in Lean); guarded away by
   the `Lambda < mu` hypotheses downstream.
4. n/a.

### 4.3 `dynScale` (def)

1. `dynScale b mu gSq = mu * exp(-1/(2 b gSq))` -- RG-invariant dimensionful
   scale reconstructed from a reference `mu` and coupling `gSq`.
2. Definition; faithful to the standard transmutation formula.
3. Junk at `b = 0` or `gSq = 0`. Normalization input: the exponent form assumes
   the one-loop coefficient `b` and the reference `mu` are the supplied inputs.
4. n/a.

### 4.4 `runningInv_pos` (theorem)

1. `0 < b`, `0 < Lambda`, `Lambda < mu` imply `0 < runningInv b Lambda mu`.
2. True, nonvacuous, correct.
3. `Lambda < mu` (AF/physical branch) is the load-bearing hypothesis: at
   `mu <= Lambda` the log is <= 0 and positivity fails. Correct guard.
4. n/a.
5. Supports "the inverse coupling is positive above the reference scale on the
   AF branch."
6. Feeds 4.5, 4.7.

### 4.5 `runningGSq_pos` (theorem)

1. Same hypotheses give `0 < runningGSq b Lambda mu`.
2. True, nonvacuous, correct (`div_pos` of 4.4).
3. Same branch guard.
4. n/a.
5. Supports "the running coupling stays positive on the AF branch."
6. Feeds 4.7.

### 4.6 `runningInv_cocycle` (theorem)

1. `runningInv b Lambda mu2 = runningInv b Lambda mu1 + 2 b log(mu2/mu1)` for
   positive `Lambda, mu1, mu2`.
2. True, nonvacuous, correctly shaped. This is the GENUINE RG content: the
   `Lambda`-dependence cancels in the difference, so the SHIFT between scales is
   `Lambda`-independent.
3. Needs positivity of the three scales (for log-division identities). Not
   guarded by the axiom-pin file (documentation gap only).
4. n/a.
5. Strongest supported: "The one-loop inverse coupling satisfies an exact
   additive cocycle whose increment `2 b log(mu2/mu1)` is independent of the
   reference `Lambda`." Not: "the beta function is derived" (it is the supplied
   input).
6. See 4.7.

### 4.7 `dynScale_running` (theorem) -- PINNED, MAIN SCALE CLAIM

1. On the AF branch (`0 < b`, `0 < Lambda`, `Lambda < mu`),
   `dynScale b mu (runningGSq b Lambda mu) = Lambda`: feeding the running
   coupling back into the scale formula returns exactly `Lambda`.
2. Mathematically TRUE and correctly shaped, BUT **the circularity caution is
   confirmed**: `Lambda` is baked into `runningInv` (4.1), so this is an exact
   round-trip identity `Lambda -> runningInv -> runningGSq -> dynScale -> Lambda`.
   It is RG-consistency (the reconstruction is well posed and `mu`-independent),
   NOT a derivation or prediction of a scale. Not vacuous (both sides nontrivial
   functions of the inputs), no false shape, but a manuscript must not read it as
   "the theory generates `Lambda`." Docstring ("returns exactly `Lambda`") is
   accurate and appropriately modest; the `/-!`-header explicitly disclaims
   "predict a measured energy scale," which is the correct hedge.
3. `Lambda < mu` is load-bearing: at `mu = Lambda`, `runningInv = 0`,
   `runningGSq = 0` (junk), and `dynScale = mu != Lambda`, so the theorem is
   FALSE without the branch hypothesis. Good that it is required.
4. Control/witness is 4.8, a nondegenerate numeric instance (couplings and scale
   all not equal to trivial 0), excluding the degenerate `log = 0` point.
5. Strongest supported: "Dimensional transmutation is algebraically consistent:
   the RG-invariant scale reconstructed from the one-loop running coupling on the
   asymptotically-free branch equals the input scale `Lambda`, independent of the
   reference `mu`." Strongest NOT supported: "The theory generates / predicts the
   physical scale `Lambda`" -- `Lambda` is an input parameter of the running law,
   so the theorem is a self-consistency (round-trip) statement, not a generation
   of a new scale from more primitive data.
6. Highest-value composition to the carrier: break the circularity by feeding the
   coupling from carrier data. Proposed `carrier_generated_scale`:
   shape -- let `gSq_carrier(mu)` be the running coupling produced by the carrier
   coarse-graining `R_ell` (NOT by a `Lambda`-parametrized formula), and define
   `Lambda_gen := dynScale b mu (gSq_carrier mu)`; prove `Lambda_gen` is
   independent of `mu` (RG invariance) using `runningInv_cocycle`.
   Kill condition: show `dynScale b mu1 (gSq_carrier mu1) != dynScale b mu2
   (gSq_carrier mu2)` for some `mu1, mu2` -- i.e. the carrier-supplied coupling
   does NOT satisfy the one-loop cocycle. If it fails, no scale is generated and
   the transmutation claim is non-physical; if it holds, the scale is genuinely
   emergent rather than an inverted input.

### 4.8 `exponential_witness` (theorem) -- PINNED, FIXTURE

1. `runningGSq (1/2) 1 e = 1` AND `dynScale (1/2) e 1 = 1`: the
   `(b,Lambda,mu) = (1/2,1,e)` fixture gives unit coupling and reconstructs unit
   scale.
2. True, nonvacuous, correct. Concrete nondegenerate instance (`log(e) = 1 != 0`,
   couplings positive), so it certifies 4.7 is not vacuous on an all-trivial
   point.
3. Fixed numeric fixture. Note the two clauses use `Lambda = 1` in the first and
   an implicit `Lambda = 1` target in the second (dynScale returns 1 = Lambda),
   consistent.
4. Yes -- excludes the degenerate `mu = Lambda`/`log = 0` point by choosing
   `mu = e > 1 = Lambda`.
5. Supports "a concrete AF fixture reproduces unit coupling and reconstructs its
   input scale." Not: "e is a physical energy."
6. Serves as the nondegenerate instance for `carrier_generated_scale`.

--------------------------------------------------------------------------------

## Module 5 -- OvernightTheoryAxiomGuard.lean

Namespace `PhysicsSM.Draft.NullEdge.OvernightTheoryAxiomGuard`.

1. Not mathematical content: eight `#guard_msgs` + `#print axioms` pins asserting
   that the four main payloads and their four witnesses depend only on
   `[propext, Classical.choice, Quot.sound]`.
2. Correctly shaped as a build-time footprint guard. No vacuity concern -- if any
   pinned theorem acquired `sorryAx` or a custom axiom, the `#guard_msgs` string
   would mismatch and the file would fail to elaborate.
3. Coverage gap (already noted globally): only 8 declarations are pinned; the
   helper lemmas (`runningInv_cocycle`, positivity lemmas, generators-commute,
   `left_qubit_noncommutative`, the SSB helpers, `resetK_tracePreserving`,
   `reset_changes_joint_state`, `regional_generation`, `regional_isotony`) are
   unguarded. They are dependencies of pinned results or share the same footprint,
   so soundness is not threatened, but a manuscript should not claim "the whole
   suite is axiom-pinned."
4. n/a.
5. Supports "the four landing theorems and their controls use only the standard
   kernel axioms." Not: "every declaration in the four modules is individually
   guarded."
6. Composition recommendation: extend the guard to the six proposed carrier-level
   composition theorems (`carrier_local_no_signaling`, `carrier_region_split`,
   `carrier_nondegenerate_no_ssb`, `carrier_generated_scale`) once landed, with
   the same allowed-axiom string, so the carrier bridge inherits the pin.
   Kill condition: any carrier composition that requires `native_decide`
   (introducing `Lean.ofReduceBool`) or a new `axiom` should be flagged by an
   unchanged `#guard_msgs` line failing to match.

--------------------------------------------------------------------------------

## Cross-cutting verdict

- **Kraus generality (confirmed).** `partialTraceB_applyLocalKrausB` holds for
  arbitrary complex matrices `rho` and arbitrary families `K` satisfying only the
  quadratic completeness relation: algebraically stronger, physically less
  specific (no state space, no CP). Safe to publish as an operational identity;
  unsafe to publish as a physics no-signaling theorem over density matrices.

- **Two-factor commutation vs emergent locality (confirmed).**
  `separated_regions_commute` / `two_qubit_local_net_verdict` are exact
  commutation of a SUPPLIED tensor factorization, paired with genuine internal
  noncommutativity. This is tautological locality, not derived microcausality;
  the header disclaims the stronger reading correctly.

- **Finite degeneracy: necessary, not sufficient (confirmed).**
  `simple_eigenstate_density_invariant` proves nondegeneracy forbids breaking
  (degeneracy necessary); `degenerate_symmetry_breaking_witness` proves
  degeneracy merely PERMITS a moved representative (not SSB). No sufficiency,
  order parameter, or limit is established.

- **Generated scale circularity (confirmed).** `dynScale_running` is an exact
  round-trip inversion because `Lambda` is defined into `runningInv`. It is RG
  self-consistency, not scale generation. The genuine new content is
  `runningInv_cocycle` (the `Lambda`-independent increment). Any "the theory
  generates Lambda" sentence is unsupported until the coupling is sourced from
  carrier data rather than a `Lambda`-parametrized law.

- **Axioms.** All eight pinned landings sit within the allowed kernel budget;
  no `sorry`/custom axiom/`native_decide` detected in the read. Guard coverage is
  a strict subset of the public surface.

END OF REPORT.
