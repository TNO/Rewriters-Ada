with Libadalang.Analysis;             use Libadalang.Analysis;
with Libadalang.Common;               use Libadalang.Common;
with Placeholder_Relations;           use Placeholder_Relations;
with Rejuvenation;                    use Rejuvenation;
with Rejuvenation.Match_Patterns;     use Rejuvenation.Match_Patterns;
with Rejuvenation.Patterns;           use Rejuvenation.Patterns;
with Rewriters_Find_And_Replace;      use Rewriters_Find_And_Replace;
with Rewriters_Sequence;              use Rewriters_Sequence;
with Rewriters_Vectors;               use Rewriters_Vectors;
with Match_Accepters_Function_Access; use Match_Accepters_Function_Access;

package Predefined_Rewriters_Append is

   function Accept_Var_Unbounded_String (Match : Match_Pattern) return Boolean
   is
      (Is_Unbounded_String (Match, "$S_Var"));

   function Accept_Append_To_Unbounded_String
     (Match : Match_Pattern)
      return Boolean
   is
     (Is_String_Expression (Match, "$S_Expr") and then
      Is_Referenced_Decl_Defined_In_AStrUnb
        (Match.Get_Nodes.First_Element.As_Call_Stmt.F_Call));

   Rewriter_Append_To_Unbounded_String :
     aliased constant Rewriter_Find_And_Replace :=
     Make_Rewriter_Find_And_Replace
       (Make_Pattern
          ("Append ($S_Var, To_Unbounded_String ($M_Source => $S_Expr));",
           Call_Stmt_Rule),
        Make_Pattern
          ("Append ($S_Var, $S_Expr);", Call_Stmt_Rule),
        Make_Match_Accepter_Function_Access
          (Accept_Append_To_Unbounded_String'Access));

   Rewriter_Ampersand_Prefer_Append :
   aliased constant Rewriter_Find_And_Replace :=
     Make_Rewriter_Find_And_Replace
       (Make_Pattern ("$S_Var := $S_Var & $S_Tail;", Assignment_Stmt_Rule),
        Make_Pattern ("Append ($S_Var, $S_Tail);", Call_Stmt_Rule),
        Make_Match_Accepter_Function_Access
          (Accept_Var_Unbounded_String'Access));

   function Accept_Independent (Match : Match_Pattern) return Boolean is
     (Are_Independent (Match, "$S_Cond", "$S_X"));

   function Accept_Conditional_Append (Match : Match_Pattern) return Boolean is
     (Accept_Var_Unbounded_String (Match) and then Accept_Independent (Match));

   Rewriter_Conditional_Append :
   aliased constant Rewriter_Find_And_Replace :=
     Make_Rewriter_Find_And_Replace
       (Make_Pattern ("if $S_Cond then $S_Var := $S_X & $S_Y; " &
            "else $S_Var := $S_X; end if;", If_Stmt_Rule),
        Make_Pattern ("$S_Var := $S_X; " &
              "if $S_Cond then Append ($S_Var, $S_Y); end if;", Stmts_Rule),
        Make_Match_Accepter_Function_Access
          (Accept_Conditional_Append'Access));

   Rewriter_Conditional_Append_Not :
   aliased constant Rewriter_Find_And_Replace :=
     Make_Rewriter_Find_And_Replace
       (Make_Pattern ("if $S_Cond then $S_Var := $S_X; " &
            "else $S_Var := $S_X & $S_Y; end if;", If_Stmt_Rule),
        Make_Pattern ("$S_Var := $S_X; " &
              "if not ($S_Cond) then Append ($S_Var, $S_Y); end if;",
          Stmts_Rule),
        Make_Match_Accepter_Function_Access
          (Accept_Conditional_Append'Access));

   Rewriter_Append : aliased constant Rewriter_Sequence :=
     Make_Rewriter_Sequence
       (Rewriter_Ampersand_Prefer_Append & Rewriter_Append_To_Unbounded_String &
       Rewriter_Conditional_Append & Rewriter_Conditional_Append_Not);
   --  Rewriter for patterns to improve the usage of the `Append` function.

   function Append_Rewrite_Context
     (Unit : Analysis_Unit)
      return Node_List.Vector;

end Predefined_Rewriters_Append;
