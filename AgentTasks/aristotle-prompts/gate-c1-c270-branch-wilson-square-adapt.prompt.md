You are working in the StandardModel Lean 4 repository on Gate C1 of the null-edge program.

Current context:
- The scalar Wilson/free symbol lives in PhysicsSM/Draft/NullEdge/GateC1/TetraScalarWilsonSymbol.lean.
- The current branch-retention scaffold lives in PhysicsSM/Draft/NullEdge/GateC1/TetraBranchWilsonSymbol.lean.
- The live scaffold defines BranchWilsonData, Kbranch, Hbranch, Kbranch_eq_scalar_K_of_W_eq_scalar, CommutesWithChirality, AnticommutesWithChirality, and BranchWilsonAudit.
- C267 previously produced useful stronger branch-mass square/gap-transfer ideas, but it rewrote the live file and removed the scalar-specialization theorem. Do not remove existing public API unless the replacement is strictly stronger and backwards-compatible.

Task:
1. Extend TetraBranchWilsonSymbol.lean with matrix-valued branch Wilson square theorems for Kbranch.
2. Preserve Kbranch_eq_scalar_K_of_W_eq_scalar or provide a backwards-compatible theorem with the same meaning.
3. Target statements should include, if feasible:
   - star(Kbranch) * Kbranch exact expansion with Q/W commutator term.
   - commuting/Hermitian simplification to qExact * I + W^2.
   - finite L2 quadratic-form decomposition or lower-bound transfer theorem.
   - Hbranch gap transfer under unitary gamma5.
4. Keep claim boundaries explicit: no locality, anomaly matching, or physical branch selection is proved by this algebra layer.
5. Do not weaken semantic statements to make proof easy. If a target needs an extra hypothesis, name it explicitly.

Success criteria:
- Lean file builds with `lake build PhysicsSM.Draft.NullEdge.GateC1.TetraBranchWilsonSymbol`.
- No proof placeholders or fake assumptions.
- Report what was proved, what hypotheses are required, and any theorem that should be asked as a follow-up.
