# Aristotle Q11 Cauchy-Binet Rescue Plan - 2026-07-07

Source Aristotle project:

- Project: `91260b54-371f-4d73-9765-813461610244`
- Task: `a07bc66f-2378-4512-aa92-5b18e187cd87`
- Job name: `ne-rescue-p02-q11-cauchybinet-minipack-20260707`
- Output summary:
  `AgentTasks/aristotle-output/91260b54-371f-4d73-9765-813461610244/extracted/project-files.tar/ne-rescue-p02-q11-cauchybinet-minipack-20260707-project_aristotle/ARISTOTLE_SUMMARY.md`

## Harvest decision

Report-only harvest.  No Lean code was integrated from this job in this pass.

The useful result is a proof-route audit for
`PhysicsSM.Draft.NullEdge.GateI1.Q11GroupAction`: the Cauchy-Binet /
exterior-power functor-law chain is already fully discharged in the partial
return, while the determinant cocycle is not part of that route and should remain
parked.

## Land-next nucleus

The next code harvest should target exactly this functor-law spine:

```lean
theorem compoundMatrix_apply (k : Nat) (g : Matrix (Fin 5) (Fin 5) Complex)
    (i j : Set.powersetCard (Fin 5) k) :
    compoundMatrix k g i j = minorDet g (i : Finset (Fin 5)) (j : Finset (Fin 5))

theorem compoundMatrix_one (k : Nat) :
    compoundMatrix k (1 : Matrix (Fin 5) (Fin 5) Complex) = 1

theorem compoundMatrix_mul (k : Nat) (g h : Matrix (Fin 5) (Fin 5) Complex) :
    compoundMatrix k (g * h) = compoundMatrix k g * compoundMatrix k h

theorem minorDet_mul (g h : Matrix (Fin 5) (Fin 5) Complex)
    (T S : Finset (Fin 5)) :
    minorDet (g * h) T S =
      sum U : Finset (Fin 5), minorDet g T U * minorDet h U S

theorem lambdaAction_mul (g h : Matrix (Fin 5) (Fin 5) Complex) (f : Form) :
    lambdaAction (g * h) f = lambdaAction g (lambdaAction h f)

theorem lambdaLinearMap_mul (g h : Matrix (Fin 5) (Fin 5) Complex) :
    lambdaLinearMap (g * h) = (lambdaLinearMap g).comp (lambdaLinearMap h)
```

The job checked that the relevant pinned Mathlib API exists:
`exteriorPower.map`, `exteriorPower.map_comp`, `exteriorPower.map_id`,
`Module.Basis.exteriorPower`, `LinearMap.toMatrix_comp`, and the needed
exterior-basis coordinate lemmas.

## Do not land yet

Do not merge the still-open `compoundMatrix_det` / Sylvester-Franke determinant
cocycle into the live nucleus.  It gates a future RC0/unimodularity claim, not
the functor law.  Until that determinant theorem is kernel-checked and reviewed,
avoid all "unimodular" or "RC0 closed" wording for this lane.

## Claim boundary

The landed target, when taken, should claim only:

- finite Cauchy-Binet for the chosen `minorDet`;
- exterior-power functoriality of `lambdaAction`;
- linear-map functoriality of `lambdaLinearMap`.

It should not claim the determinant cocycle, Jacobi closure, RC0 closure, or a
full unimodularity certificate.
