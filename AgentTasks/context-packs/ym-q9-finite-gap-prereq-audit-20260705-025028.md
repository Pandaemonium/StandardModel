# Aristotle semantic context pack

Generated: 2026-07-05T02:50:36
Query: `Q9 finite gap assembly prerequisite local algebra cyclicity strict spectral ratio localGlueballGap FiniteGapAssembly`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `Sources/Null_Edge_Gate_C1_C261_Overlap_Locality_Theorem_Plan.md` [5. Relation to the broader release plan]

Score: `0.777`

```text
## 5. Relation to the broader release plan

* This is the overlap-lane companion to the algebraic Ginsparg–Wilson identity
  already in `OverlapGinspargWilson.lean` (`dov_ginsparg_wilson`).
* It supplies the "exponential locality as a sufficient theorem" brick the plan
  asks for, without making it the primitive control notion: locality here is a
  *consequence* of finite-range structure plus spectral (gap-driven)
  approximation data.
* The remaining physics inputs (that a genuine gapped Hermitian `H` has such
  exponentially good, linearly-growing-degree polynomial sign approximants) are
  the spectral-analysis hypotheses packaged as the theorem's premises; the
  kinematic conversion to locality is now fully verified.
```

### 2. `AgentTasks/null-edge-grand-strategy-v3-output.md` [8. Audit: is P9 stronger, weaker, or just cleaner?]

Score: `0.769`

```text
out the gaps that keep P9 Aspirational:
* the `Bivector := Fin 3 → ℝ` carrier is a **toy `su(2)_L` stand-in** with no
  linear-simplicity (EPRL vs degenerate vs `II±`) sector tracking;
* the SJ reference is **pre-area-law / pre-truncation**;
* the model actually used has **no homology gap** demonstrated
  (`IsBoundaryExact` vs `IsBFClosed` are stated distinct, but a *closed-not-exact*
  witness is not yet built — and that gap is exactly where the physics lives);
* `recoverabilityGap controls sourceVisibility` is still only a **conjecture**;
* the **everpresent-Λ amplitude tension** has no new suppression mechanism.

So P9's *leverage* (highest-risk, highest-reward cosmology branch) is unchanged,
but its *floor* rose: the finite skeleton is now clean, checked, and correctly
separated, which is precisely what lets the next agent build the homology-gap and
recoverability layers without re-deriving the separation each time. The right
status label remains **Aspirational**, now with a trustworthy finite spine
underneath it.

---
```

### 3. `AgentTasks/autonomous-loop/progress.md` [Cycle 24 - 2026-06-27 - finite locality-certificate guardrails formalized]

Score: `0.764`

```text
## Cycle 24 - 2026-06-27 - finite locality-certificate guardrails formalized

- Aristotle poll: no newly completed active jobs; C101, P16, P17, C89, C92, C93, C82, and C70 remain running.
- Literature search: ran `neo4j_paper_search.py --chunks --query "Ginsparg Wilson non ultralocal quasi local overlap locality certificate projector"`.
- Literature result: top hit again noted that Ginsparg-Wilson operators sacrifice ultralocality; other hits involved local/no-go constraints. Plan impact: formalize the difference between formal projectors, quasi-local decay certificates, and finite-range locality certificates.
- Track A/Lean: added `PhysicsSM/Draft/NullEdgeLocalityCertificateToy.lean`, proving a formal projector does not imply any locality certificate, and a decay/quasi-local certificate is not the same as a finite-range certificate.
- Track A/root wiring: imported the new module in `PhysicsSMDraft.lean`.
- Track B: the new module formalizes the locality-vs-ultralocality guardrail from cycle 17 in finite toy form.
- Validation: `lake env lean PhysicsSM/Draft/NullEdgeLocalityCertificateToy.lean` passed.
- Validation: `lake build PhysicsSM.Draft.NullEdgeLocalityCertificateToy` passed.
- Validation: `lake env lean PhysicsSMDraft.lean` passed.
- Claude/Pro: no new call.
```

### 4. `AgentTasks/null-edge-grand-strategy-v2-output.md` [1. Ranked roadmap — next jobs]

Score: `0.764`

```text
ite spectral-triple audit of `D_{U,Φ}` | design + focused | first-order condition forces Yukawa legality |
| 11 | B′ | l=1 relaxation gap as channel/generator spectral target | focused standalone | depends on B; sharpens flip-rate conjecture |
| 12 | G′ | Discrete ANEC/QNEC positivity gate for diamond source | focused standalone | depends on G defs |
| 13 | E′ | Gram-weighted reduced-density (nonorthogonal labels) wrapper | focused standalone | extends E to coherent internal labels |
| 14 | D′ | `edgeNeighbor_N` finite locality relation + monotonicity | focused standalone | independent; small |

Jobs 1–5 are the "do these next" tranche: each is a single decisive finite
theorem resting on banked anchors with bounded convention risk. Jobs 6–8 unlock
the structural backbone. Jobs 9–14 are second-wave.

---
```

### 5. `Sources/Null_Edge_Gate_C1_Nonultralocal_Release_Plan.md` [45. Integrated Aristotle update: C204-C208 free-gate assembly layer]

Score: `0.764`

```text
lity;
C202 maintained spectral island.
```

It explicitly excludes:

```text
background-gauge claims;
determinant-line claims;
anomaly claims;
ghost-sector claims;
quantum/loop claims.
```

C208 supplies the missing-source priority table:

```text
P1 Kato:
  Riesz projection and isolated spectral subspace stability.

P2 Davis-Kahan:
  quantitative spectral-subspace perturbation bounds.

P3 Hasenfratz-Laliena-Niedermayer:
  lattice index theorem from the Ginsparg-Wilson relation.

P4 Narayanan-Neuberger:
  vacuum-overlap and determinant-line origin.

P5 Fujikawa:
  secondary continuum chiral-Jacobian cross-check.
```

Updated status:

```text
GateC1_NU_Free now has an abstract external assembly theorem.
The reference-side gap is externally formalized, modulo the concrete Clifford
anticommutation input.
The null-edge-side kappa certificate is decomposed.
The remaining hard task is concrete instantiation:
  actual H_ne data,
  actual transport S,
  CKM/R matching,
  numeric or symbolic bounds for kappaBranch+kappaKin+kappaWil < gamma_free.
```
```

### 6. `PhysicsSM/Draft/NullEdgeP9OperationalGap.lean` [t1_localSignature_distinguishable_threshold_two]

Score: `0.762`

```text
theorem t1_localSignature_distinguishable_threshold_two :
    distinguishableAt (localIntervalSignature relA 0 4)
      (localIntervalSignature relB 0 4) (Fin.mk 1 (by decide)) 2 := by
  unfold distinguishableAt
  rw [t1_localSignature_gap_at_one]

end PhysicsSM.Draft.NullEdgeP9OperationalGap
end
```

### 7. `Sources/Null_Edge_Gate_C1_Nonultralocal_Release_Plan.md` [57.6 Updated local work order]

Score: `0.760`

```text
### 57.6 Updated local work order

Use this order for the next local/Aristotle rounds:

```text
1. Claim-boundary API:
   GateC1_local, GateC1_NU, GateC1_formal.

2. Wilson/overlap reference mass window.

3. Null-edge Hermitian or RA-dilated kernel definition.

4. Null-edge-to-Wilson free symbol/sector match.

5. Gapped homotopy stability / reference import.

6. Sign-function and Ginsparg-Wilson import.

7. Branch-line spectral lift.

8. Bad-sector inverse gap and no-ghost theorem.

9. Standard Model gauge-internality/dressing.

10. Path-sum/resolvent/domain-wall control.

11. Anomaly/determinant-line source contract.

12. Null-Edge Overlap release assembly.
```

Status boundary:

```text
This update further narrows the operator target.
It still does not define the actual project H_NE or prove the kappa/gap bound.
The raw retarded operator remains a seed/path object, not the sign-kernel.
```
```

### 8. `Sources/Null_Edge_Gate_C1_Nonultralocal_Release_Plan.md` [28. Integrated Aristotle update: kernel-only finite seed and flavored-overlap interpretation]

Score: `0.759`

```text
han the reference gap. This makes the next reference-matching step finite and computable.

C151 links Hernandez-Jansen-Luscher locality to null-edge path-shell summability. Exponential locality and ultralocality are sufficient special cases; the natural null-edge condition is controlled shell-count/amplitude summability.

C152 gives a domain-wall/topological-boundary fallback: if native overlap stalls, import mode can be phrased as equality or homotopy of the boundary sign class `T_br`, after which the finite overlap/GW algebra transfers.

Updated working interpretation:

```text
W_branch = null-edge flavored/species-splitting Wilson term
H_ne = Gamma_K (D_ne + W_branch - m0 R)
T_br = sign(H_ne)
D_ov,ne = rho (1 + Gamma_K T_br)
```

The project should now focus on choosing a concrete flavor-matched reference kernel, comparing sector signatures, and proving a gapped homotopy/locality/anomaly import path.
```

## Scoped paper hits

### 1. Locality properties of Neuberger's lattice Dirac operator

Score: `0.731`
Zotero key: `BEG87SU5`
arXiv: `hep-lat/9808010`
URL: https://arxiv.org/abs/hep-lat/9808010

### 2. Hodgelets: Localized Spectral Representations of Flows on Simplicial Complexes

Score: `0.706`
Zotero key: `33X7ZETB`
arXiv: `2109.08728`
URL: http://arxiv.org/abs/2109.08728

### 3. Localized States for Elementary Systems

Score: `0.704`
Zotero key: `74NU4C33`
DOI: `10.1103/revmodphys.21.400`
URL: https://doi.org/10.1103/revmodphys.21.400

### 4. Extension of the Nielsen-Ninomiya theorem

Score: `0.704`
Zotero key: `arxiv:hep-lat/9803002`
arXiv: `hep-lat/9803002`
DOI: `10.1103/PhysRevD.58.057505`
URL: http://arxiv.org/abs/hep-lat/9803002

Abstract:

Extends the Nielsen-Ninomiya no-go theorem for lattice chiral Dirac fermions using the index theorem, including translation non-invariant and non-local formulations.

### 5. Quantum geometric tensor determines the pure-state i.i.d. conversion rate in the resource theory of asymmetry for any compact Lie group

Score: `0.703`
Zotero key: `45FTB5VF`
arXiv: `2411.04766`
URL: http://arxiv.org/abs/2411.04766

Abstract:

Shows that the quantum geometric tensor determines pure-state iid conversion rates in the resource theory of asymmetry for compact Lie groups.
