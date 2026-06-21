# Aristotle task: causal-diamond higher-gauge wrapper

Date: 2026-06-21

## Goal

Prove the finite higher-gauge wrapper lemmas around the trusted causal-diamond
holonomy composition API.

Target file:

```text
PhysicsSM/Draft/CausalDiamondHigherGaugeAristotle.lean
```

This builds on:

```text
PhysicsSM/Gauge/CausalDiamondHolonomy.lean
```

## Why this target

The trusted module already proves:

- non-Abelian endpoint covariance of one diamond defect;
- class-function gauge invariance;
- vertical and horizontal composition laws for path-pair defects;
- Abelian multiplication under vertical gluing.

The next useful layer is to package the non-Abelian correction as explicit
basepoint transport / whiskering, then prove the elementary coherence laws
needed before attempting a 2-categorical diamond API.

## Target declarations

```lean
transportDefect_one
transportDefect_mul
transportDefect_comp
pathPairDefect_verticalCompose_transport
verticalComposePathPair_assoc
horizontalComposePathPair_assoc
pathPair_interchange
```

## Proof guidance

All targets are finite group or semigroup algebra.

Use:

```lean
simp [transportDefect, pathPairDefect, verticalComposePathPair,
  horizontalComposePathPair, mul_assoc]
```

and, where needed:

```lean
ext <;> simp [verticalComposePathPair, horizontalComposePathPair, mul_assoc]
```

Do not weaken the statements. Helper lemmas are welcome in the same file if
they make the proof clearer.

## Claim boundary

This task does not formalize:

- smooth surface holonomy;
- non-Abelian Stokes theorem;
- gerbes or principal 2-bundles;
- a full double category or bicategory.

It is only the finite algebraic coherence layer that makes those later
interpretations precise enough to discuss.

## Literature context

New source anchors added to Zotero/Neo4j for this wave:

- Wilson, *Confinement of quarks*, `10.1103/PhysRevD.10.2445`, existing Zotero key `QDII2KHM`.
- Baez-Schreiber, *Higher gauge theory*, `10.1090/conm/431/08264`, Zotero key `AHK54SN9`.
- Baez-Huerta, *An invitation to higher gauge theory*, `10.1007/s10714-010-1070-9`, Zotero key `K9XTAJUM`.
- Schreiber-Waldorf, *Connections on non-abelian Gerbes and their Holonomy*, `arXiv:0808.1923`, Zotero key `Z38RZX2Q`.

## Verification

Run:

```text
lake env lean PhysicsSM/Draft/CausalDiamondHigherGaugeAristotle.lean
lake build PhysicsSM.Draft.CausalDiamondHigherGaugeAristotle
```

Then scan the target file for proof-command placeholders and forbidden
constructs.

## Submission

```yaml
aristotle:
  project_id: 0897a0dd-888e-451f-97e7-e24633cd2699
  task_id: a0748c78-baba-4edc-8f4e-ba71f1798110
  target_file: PhysicsSM/Draft/CausalDiamondHigherGaugeAristotle.lean
  expected_module: PhysicsSM.Draft.CausalDiamondHigherGaugeAristotle
  submission_project: AgentTasks/aristotle-submit/causal-diamond-higher-gauge-20260621-project
  output_dir: AgentTasks/aristotle-output/0897a0dd-888e-451f-97e7-e24633cd2699
  status: integrated
  last_checked: IDLE
  integrated_file: PhysicsSM/Draft/CausalDiamondHigherGaugeAristotle.lean
  integrated_at: 2026-06-21
  verification:
    - lake build PhysicsSM.Draft.CausalDiamondHigherGaugeAristotle
```
