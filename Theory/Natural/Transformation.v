Set Warnings "-notation-overridden".

Require Import Category.Lib.
Require Export Category.Theory.Functor.
Require Export Category.Theory.Naturality.

Generalizable All Variables.
Set Primitive Projections.
Set Universe Polymorphism.
Unset Transparent Obligations.

Section Transform.

Context {C : Category}.
Context {D : Category}.
Context {F : C ⟶ D}.
Context {G : C ⟶ D}.

Class Transform := {
  transform {X} : F X ~> G X;

  naturality {X Y} (f : X ~> Y) :
    fmap[G] f ∘ transform ≈ transform ∘ fmap[F] f;

  naturality_sym {X Y} (f : X ~> Y) :
    transform ∘ fmap[F] f ≈ fmap[G] f ∘ transform
}.

Global Program Instance Transform_Setoid : Setoid Transform.

End Transform.

Arguments transform {_ _ _ _} _ _.
Arguments naturality
  {_ _ _ _ _ _ _ _}, {_ _ _ _} _ {_ _ _}, {_ _ _ _} _ _ _ _.
Arguments naturality_sym
  {_ _ _ _ _ _ _ _}, {_ _ _ _} _ {_ _ _}, {_ _ _ _} _ _ _ _.

Bind Scope transform_scope with Transform.
Delimit Scope transform_type_scope with transform_type.
Delimit Scope transform_scope with transform.
Open Scope transform_type_scope.
Open Scope transform_scope.

Notation "F ⟹ G" := (@Transform _ _ F%functor G%functor)
  (at level 90, right associativity) : transform_type_scope.

Notation "transform[ F ]" := (@transform _ _ _ _ F%transform)
  (at level 9, only parsing, format "transform[ F ]") : morphism_scope.
Notation "naturality[ F ]" := (@naturality _ _ _ _ F%transform)
  (at level 9, only parsing, format "naturality[ F ]") : morphism_scope.

Coercion transform : Transform >-> Funclass.

Ltac transform :=
  unshelve (refine {| transform := _ |}; simpl; intros).

Definition outside {C : Category} {D : Category}
           {F G : C ⟶ D} `(N : F ⟹ G)
           {E : Category} (X : E ⟶ C) : F ○ X ⟹ G ○ X.
Proof.
  transform; intros; simpl.
  - apply N.
  - abstract apply naturality.
  - abstract apply naturality_sym.
Defined.

Definition inside {C : Category} {D : Category}
           {F G : C ⟶ D} `(N : F ⟹ G)
           {E : Category} (X : D ⟶ E) : X ○ F ⟹ X ○ G.
Proof.
  transform; intros; simpl.
  - apply fmap, N.
  - abstract (
      simpl; rewrite <- !fmap_comp;
      apply fmap_respects, naturality).
  - abstract (
      simpl; rewrite <- !fmap_comp;
      apply fmap_respects, naturality_sym).
Defined.
