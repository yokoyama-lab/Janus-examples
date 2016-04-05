{-# OPTIONS_GHC -fno-warn-incomplete-patterns #-}
module PrintC where

-- pretty-printer generated by the BNF converter

import AbsC
import Data.Char


-- the top-level printing method
printTree :: Print a => a -> String
printTree = render . prt 0

type Doc = [ShowS] -> [ShowS]

doc :: ShowS -> Doc
doc = (:)

render :: Doc -> String
render d = rend 0 (map ($ "") $ d []) "" where
  rend i ss = case ss of
    "["      :ts -> showChar '[' . rend i ts
    "("      :ts -> showChar '(' . rend i ts
    "{"      :ts -> showChar '{' . new (i+1) . rend (i+1) ts
    "}" : ";":ts -> new (i-1) . space "}" . showChar ';' . new (i-1) . rend (i-1) ts
    "}"      :ts -> new (i-1) . showChar '}' . new (i-1) . rend (i-1) ts
    ";"      :ts -> showChar ';' . new i . rend i ts
    t  : "," :ts -> showString t . space "," . rend i ts
    t  : ")" :ts -> showString t . showChar ')' . rend i ts
    t  : "]" :ts -> showString t . showChar ']' . rend i ts
    t        :ts -> space t . rend i ts
    _            -> id
  new i   = showChar '\n' . replicateS (2*i) (showChar ' ') . dropWhile isSpace
  space t = showString t . (\s -> if null s then "" else (' ':s))

parenth :: Doc -> Doc
parenth ss = doc (showChar '(') . ss . doc (showChar ')')

concatS :: [ShowS] -> ShowS
concatS = foldr (.) id

concatD :: [Doc] -> Doc
concatD = foldr (.) id

replicateS :: Int -> ShowS -> ShowS
replicateS n f = concatS (replicate n f)

-- the printer class does the job
class Print a where
  prt :: Int -> a -> Doc
  prtList :: [a] -> Doc
  prtList = concatD . map (prt 0)

instance Print a => Print [a] where
  prt _ = prtList

instance Print Char where
  prt _ s = doc (showChar '\'' . mkEsc '\'' s . showChar '\'')
  prtList s = doc (showChar '"' . concatS (map (mkEsc '"') s) . showChar '"')

mkEsc :: Char -> Char -> ShowS
mkEsc q s = case s of
  _ | s == q -> showChar '\\' . showChar s
  '\\'-> showString "\\\\"
  '\n' -> showString "\\n"
  '\t' -> showString "\\t"
  _ -> showChar s

prPrec :: Int -> Int -> Doc -> Doc
prPrec i j = if j<i then parenth else id


instance Print Integer where
  prt _ x = doc (shows x)


instance Print Double where
  prt _ x = doc (shows x)


instance Print Ident where
  prt _ (Ident i) = doc (showString ( i))
  prtList es = case es of
   [x] -> (concatD [prt 0 x])
   x:xs -> (concatD [prt 0 x , doc (showString ",") , prt 0 xs])


instance Print Unsigned where
  prt _ (Unsigned i) = doc (showString ( i))


instance Print Long where
  prt _ (Long i) = doc (showString ( i))


instance Print UnsignedLong where
  prt _ (UnsignedLong i) = doc (showString ( i))


instance Print Hexadecimal where
  prt _ (Hexadecimal i) = doc (showString ( i))


instance Print HexUnsigned where
  prt _ (HexUnsigned i) = doc (showString ( i))


instance Print HexLong where
  prt _ (HexLong i) = doc (showString ( i))


instance Print HexUnsLong where
  prt _ (HexUnsLong i) = doc (showString ( i))


instance Print Octal where
  prt _ (Octal i) = doc (showString ( i))


instance Print OctalUnsigned where
  prt _ (OctalUnsigned i) = doc (showString ( i))


instance Print OctalLong where
  prt _ (OctalLong i) = doc (showString ( i))


instance Print OctalUnsLong where
  prt _ (OctalUnsLong i) = doc (showString ( i))


instance Print CDouble where
  prt _ (CDouble i) = doc (showString ( i))


instance Print CFloat where
  prt _ (CFloat i) = doc (showString ( i))


instance Print CLongDouble where
  prt _ (CLongDouble i) = doc (showString ( i))



instance Print Program where
  prt i e = case e of
   Progr external_declarations -> prPrec i 0 (concatD [prt 0 external_declarations])


instance Print External_declaration where
  prt i e = case e of
   Afunc function_def -> prPrec i 0 (concatD [prt 0 function_def])
   Global dec -> prPrec i 0 (concatD [prt 0 dec])

  prtList es = case es of
   [x] -> (concatD [prt 0 x])
   x:xs -> (concatD [prt 0 x , prt 0 xs])

instance Print Function_def where
  prt i e = case e of
   OldFunc declaration_specifiers declarator decs compound_stm -> prPrec i 0 (concatD [prt 0 declaration_specifiers , prt 0 declarator , prt 0 decs , prt 0 compound_stm])
   NewFunc declaration_specifiers declarator compound_stm -> prPrec i 0 (concatD [prt 0 declaration_specifiers , prt 0 declarator , prt 0 compound_stm])
   OldFuncInt declarator decs compound_stm -> prPrec i 0 (concatD [prt 0 declarator , prt 0 decs , prt 0 compound_stm])
   NewFuncInt declarator compound_stm -> prPrec i 0 (concatD [prt 0 declarator , prt 0 compound_stm])


instance Print Dec where
  prt i e = case e of
   NoDeclarator declaration_specifiers -> prPrec i 0 (concatD [prt 0 declaration_specifiers , doc (showString ";")])
   Declarators declaration_specifiers init_declarators -> prPrec i 0 (concatD [prt 0 declaration_specifiers , prt 0 init_declarators , doc (showString ";")])

  prtList es = case es of
   [x] -> (concatD [prt 0 x])
   x:xs -> (concatD [prt 0 x , prt 0 xs])

instance Print Declaration_specifier where
  prt i e = case e of
   Type type_specifier -> prPrec i 0 (concatD [prt 0 type_specifier])
   Storage storage_class_specifier -> prPrec i 0 (concatD [prt 0 storage_class_specifier])
   SpecProp type_qualifier -> prPrec i 0 (concatD [prt 0 type_qualifier])

  prtList es = case es of
   [x] -> (concatD [prt 0 x])
   x:xs -> (concatD [prt 0 x , prt 0 xs])

instance Print Init_declarator where
  prt i e = case e of
   OnlyDecl declarator -> prPrec i 0 (concatD [prt 0 declarator])
   InitDecl declarator initializer -> prPrec i 0 (concatD [prt 0 declarator , doc (showString "=") , prt 0 initializer])

  prtList es = case es of
   [x] -> (concatD [prt 0 x])
   x:xs -> (concatD [prt 0 x , doc (showString ",") , prt 0 xs])

instance Print Type_specifier where
  prt i e = case e of
   Tvoid  -> prPrec i 0 (concatD [doc (showString "void")])
   Tchar  -> prPrec i 0 (concatD [doc (showString "char")])
   Tshort  -> prPrec i 0 (concatD [doc (showString "short")])
   Tint  -> prPrec i 0 (concatD [doc (showString "int")])
   Tlong  -> prPrec i 0 (concatD [doc (showString "long")])
   Tfloat  -> prPrec i 0 (concatD [doc (showString "float")])
   Tdouble  -> prPrec i 0 (concatD [doc (showString "double")])
   Tsigned  -> prPrec i 0 (concatD [doc (showString "signed")])
   Tunsigned  -> prPrec i 0 (concatD [doc (showString "unsigned")])
   Tstruct struct_or_union_spec -> prPrec i 0 (concatD [prt 0 struct_or_union_spec])
   Tenum enum_specifier -> prPrec i 0 (concatD [prt 0 enum_specifier])
   Tname  -> prPrec i 0 (concatD [doc (showString "Typedef_name")])


instance Print Storage_class_specifier where
  prt i e = case e of
   MyType  -> prPrec i 0 (concatD [doc (showString "typedef")])
   GlobalPrograms  -> prPrec i 0 (concatD [doc (showString "extern")])
   LocalProgram  -> prPrec i 0 (concatD [doc (showString "static")])
   LocalBlock  -> prPrec i 0 (concatD [doc (showString "auto")])
   LocalReg  -> prPrec i 0 (concatD [doc (showString "register")])


instance Print Type_qualifier where
  prt i e = case e of
   Const  -> prPrec i 0 (concatD [doc (showString "const")])
   NoOptim  -> prPrec i 0 (concatD [doc (showString "volatile")])

  prtList es = case es of
   [x] -> (concatD [prt 0 x])
   x:xs -> (concatD [prt 0 x , prt 0 xs])

instance Print Struct_or_union_spec where
  prt i e = case e of
   Tag struct_or_union id struct_decs -> prPrec i 0 (concatD [prt 0 struct_or_union , prt 0 id , doc (showString "{") , prt 0 struct_decs , doc (showString "}")])
   Unique struct_or_union struct_decs -> prPrec i 0 (concatD [prt 0 struct_or_union , doc (showString "{") , prt 0 struct_decs , doc (showString "}")])
   TagType struct_or_union id -> prPrec i 0 (concatD [prt 0 struct_or_union , prt 0 id])


instance Print Struct_or_union where
  prt i e = case e of
   Struct  -> prPrec i 0 (concatD [doc (showString "struct")])
   Union  -> prPrec i 0 (concatD [doc (showString "union")])


instance Print Struct_dec where
  prt i e = case e of
   Structen spec_quals struct_declarators -> prPrec i 0 (concatD [prt 0 spec_quals , prt 0 struct_declarators , doc (showString ";")])

  prtList es = case es of
   [x] -> (concatD [prt 0 x])
   x:xs -> (concatD [prt 0 x , prt 0 xs])

instance Print Spec_qual where
  prt i e = case e of
   TypeSpec type_specifier -> prPrec i 0 (concatD [prt 0 type_specifier])
   QualSpec type_qualifier -> prPrec i 0 (concatD [prt 0 type_qualifier])

  prtList es = case es of
   [x] -> (concatD [prt 0 x])
   x:xs -> (concatD [prt 0 x , prt 0 xs])

instance Print Struct_declarator where
  prt i e = case e of
   Decl declarator -> prPrec i 0 (concatD [prt 0 declarator])
   Field constant_expression -> prPrec i 0 (concatD [doc (showString ":") , prt 0 constant_expression])
   DecField declarator constant_expression -> prPrec i 0 (concatD [prt 0 declarator , doc (showString ":") , prt 0 constant_expression])

  prtList es = case es of
   [x] -> (concatD [prt 0 x])
   x:xs -> (concatD [prt 0 x , doc (showString ",") , prt 0 xs])

instance Print Enum_specifier where
  prt i e = case e of
   EnumDec enumerators -> prPrec i 0 (concatD [doc (showString "enum") , doc (showString "{") , prt 0 enumerators , doc (showString "}")])
   EnumName id enumerators -> prPrec i 0 (concatD [doc (showString "enum") , prt 0 id , doc (showString "{") , prt 0 enumerators , doc (showString "}")])
   EnumVar id -> prPrec i 0 (concatD [doc (showString "enum") , prt 0 id])


instance Print Enumerator where
  prt i e = case e of
   Plain id -> prPrec i 0 (concatD [prt 0 id])
   EnumInit id constant_expression -> prPrec i 0 (concatD [prt 0 id , doc (showString "=") , prt 0 constant_expression])

  prtList es = case es of
   [x] -> (concatD [prt 0 x])
   x:xs -> (concatD [prt 0 x , doc (showString ",") , prt 0 xs])

instance Print Declarator where
  prt i e = case e of
   BeginPointer pointer direct_declarator -> prPrec i 0 (concatD [prt 0 pointer , prt 0 direct_declarator])
   NoPointer direct_declarator -> prPrec i 0 (concatD [prt 0 direct_declarator])


instance Print Direct_declarator where
  prt i e = case e of
   Name id -> prPrec i 0 (concatD [prt 0 id])
   ParenDecl declarator -> prPrec i 0 (concatD [doc (showString "(") , prt 0 declarator , doc (showString ")")])
   InnitArray direct_declarator constant_expression -> prPrec i 0 (concatD [prt 0 direct_declarator , doc (showString "[") , prt 0 constant_expression , doc (showString "]")])
   Incomplete direct_declarator -> prPrec i 0 (concatD [prt 0 direct_declarator , doc (showString "[") , doc (showString "]")])
   NewFuncDec direct_declarator parameter_type -> prPrec i 0 (concatD [prt 0 direct_declarator , doc (showString "(") , prt 0 parameter_type , doc (showString ")")])
   OldFuncDef direct_declarator ids -> prPrec i 0 (concatD [prt 0 direct_declarator , doc (showString "(") , prt 0 ids , doc (showString ")")])
   OldFuncDec direct_declarator -> prPrec i 0 (concatD [prt 0 direct_declarator , doc (showString "(") , doc (showString ")")])


instance Print Pointer where
  prt i e = case e of
   Point  -> prPrec i 0 (concatD [doc (showString "*")])
   PointQual type_qualifiers -> prPrec i 0 (concatD [doc (showString "*") , prt 0 type_qualifiers])
   PointPoint pointer -> prPrec i 0 (concatD [doc (showString "*") , prt 0 pointer])
   PointQualPoint type_qualifiers pointer -> prPrec i 0 (concatD [doc (showString "*") , prt 0 type_qualifiers , prt 0 pointer])


instance Print Parameter_type where
  prt i e = case e of
   AllSpec parameter_declarations -> prPrec i 0 (concatD [prt 0 parameter_declarations])
   More parameter_declarations -> prPrec i 0 (concatD [prt 0 parameter_declarations , doc (showString ",") , doc (showString "...")])


instance Print Parameter_declarations where
  prt i e = case e of
   ParamDec parameter_declaration -> prPrec i 0 (concatD [prt 0 parameter_declaration])
   MoreParamDec parameter_declarations parameter_declaration -> prPrec i 0 (concatD [prt 0 parameter_declarations , doc (showString ",") , prt 0 parameter_declaration])


instance Print Parameter_declaration where
  prt i e = case e of
   OnlyType declaration_specifiers -> prPrec i 0 (concatD [prt 0 declaration_specifiers])
   TypeAndParam declaration_specifiers declarator -> prPrec i 0 (concatD [prt 0 declaration_specifiers , prt 0 declarator])
   Abstract declaration_specifiers abstract_declarator -> prPrec i 0 (concatD [prt 0 declaration_specifiers , prt 0 abstract_declarator])


instance Print Initializer where
  prt i e = case e of
   InitExpr exp -> prPrec i 0 (concatD [prt 2 exp])
   InitListOne initializers -> prPrec i 0 (concatD [doc (showString "{") , prt 0 initializers , doc (showString "}")])
   InitListTwo initializers -> prPrec i 0 (concatD [doc (showString "{") , prt 0 initializers , doc (showString ",") , doc (showString "}")])


instance Print Initializers where
  prt i e = case e of
   AnInit initializer -> prPrec i 0 (concatD [prt 0 initializer])
   MoreInit initializers initializer -> prPrec i 0 (concatD [prt 0 initializers , doc (showString ",") , prt 0 initializer])


instance Print Type_name where
  prt i e = case e of
   PlainType spec_quals -> prPrec i 0 (concatD [prt 0 spec_quals])
   ExtendedType spec_quals abstract_declarator -> prPrec i 0 (concatD [prt 0 spec_quals , prt 0 abstract_declarator])


instance Print Abstract_declarator where
  prt i e = case e of
   PointerStart pointer -> prPrec i 0 (concatD [prt 0 pointer])
   Advanced dir_abs_dec -> prPrec i 0 (concatD [prt 0 dir_abs_dec])
   PointAdvanced pointer dir_abs_dec -> prPrec i 0 (concatD [prt 0 pointer , prt 0 dir_abs_dec])


instance Print Dir_abs_dec where
  prt i e = case e of
   WithinParentes abstract_declarator -> prPrec i 0 (concatD [doc (showString "(") , prt 0 abstract_declarator , doc (showString ")")])
   Array  -> prPrec i 0 (concatD [doc (showString "[") , doc (showString "]")])
   InitiatedArray constant_expression -> prPrec i 0 (concatD [doc (showString "[") , prt 0 constant_expression , doc (showString "]")])
   UnInitiated dir_abs_dec -> prPrec i 0 (concatD [prt 0 dir_abs_dec , doc (showString "[") , doc (showString "]")])
   Initiated dir_abs_dec constant_expression -> prPrec i 0 (concatD [prt 0 dir_abs_dec , doc (showString "[") , prt 0 constant_expression , doc (showString "]")])
   OldFunction  -> prPrec i 0 (concatD [doc (showString "(") , doc (showString ")")])
   NewFunction parameter_type -> prPrec i 0 (concatD [doc (showString "(") , prt 0 parameter_type , doc (showString ")")])
   OldFuncExpr dir_abs_dec -> prPrec i 0 (concatD [prt 0 dir_abs_dec , doc (showString "(") , doc (showString ")")])
   NewFuncExpr dir_abs_dec parameter_type -> prPrec i 0 (concatD [prt 0 dir_abs_dec , doc (showString "(") , prt 0 parameter_type , doc (showString ")")])


instance Print Stm where
  prt i e = case e of
   LabelS labeled_stm -> prPrec i 0 (concatD [prt 0 labeled_stm])
   CompS compound_stm -> prPrec i 0 (concatD [prt 0 compound_stm])
   ExprS expression_stm -> prPrec i 0 (concatD [prt 0 expression_stm])
   SelS selection_stm -> prPrec i 0 (concatD [prt 0 selection_stm])
   IterS iter_stm -> prPrec i 0 (concatD [prt 0 iter_stm])
   JumpS jump_stm -> prPrec i 0 (concatD [prt 0 jump_stm])

  prtList es = case es of
   [x] -> (concatD [prt 0 x])
   x:xs -> (concatD [prt 0 x , prt 0 xs])

instance Print Labeled_stm where
  prt i e = case e of
   SlabelOne id stm -> prPrec i 0 (concatD [prt 0 id , doc (showString ":") , prt 0 stm])
   SlabelTwo constant_expression stm -> prPrec i 0 (concatD [doc (showString "case") , prt 0 constant_expression , doc (showString ":") , prt 0 stm])
   SlabelThree stm -> prPrec i 0 (concatD [doc (showString "default") , doc (showString ":") , prt 0 stm])


instance Print Compound_stm where
  prt i e = case e of
   ScompOne  -> prPrec i 0 (concatD [doc (showString "{") , doc (showString "}")])
   ScompTwo stms -> prPrec i 0 (concatD [doc (showString "{") , prt 0 stms , doc (showString "}")])
   ScompThree decs -> prPrec i 0 (concatD [doc (showString "{") , prt 0 decs , doc (showString "}")])
   ScompFour decs stms -> prPrec i 0 (concatD [doc (showString "{") , prt 0 decs , prt 0 stms , doc (showString "}")])


instance Print Expression_stm where
  prt i e = case e of
   SexprOne  -> prPrec i 0 (concatD [doc (showString ";")])
   SexprTwo exp -> prPrec i 0 (concatD [prt 0 exp , doc (showString ";")])


instance Print Selection_stm where
  prt i e = case e of
   SselOne exp stm -> prPrec i 0 (concatD [doc (showString "if") , doc (showString "(") , prt 0 exp , doc (showString ")") , prt 0 stm])
   SselTwo exp stm0 stm -> prPrec i 0 (concatD [doc (showString "if") , doc (showString "(") , prt 0 exp , doc (showString ")") , prt 0 stm0 , doc (showString "else") , prt 0 stm])
   SselThree exp stm -> prPrec i 0 (concatD [doc (showString "switch") , doc (showString "(") , prt 0 exp , doc (showString ")") , prt 0 stm])


instance Print Iter_stm where
  prt i e = case e of
   SiterOne exp stm -> prPrec i 0 (concatD [doc (showString "while") , doc (showString "(") , prt 0 exp , doc (showString ")") , prt 0 stm])
   SiterTwo stm exp -> prPrec i 0 (concatD [doc (showString "do") , prt 0 stm , doc (showString "while") , doc (showString "(") , prt 0 exp , doc (showString ")") , doc (showString ";")])
   SiterThree expression_stm0 expression_stm stm -> prPrec i 0 (concatD [doc (showString "for") , doc (showString "(") , prt 0 expression_stm0 , prt 0 expression_stm , doc (showString ")") , prt 0 stm])
   SiterFour expression_stm0 expression_stm exp stm -> prPrec i 0 (concatD [doc (showString "for") , doc (showString "(") , prt 0 expression_stm0 , prt 0 expression_stm , prt 0 exp , doc (showString ")") , prt 0 stm])


instance Print Jump_stm where
  prt i e = case e of
   SjumpOne id -> prPrec i 0 (concatD [doc (showString "goto") , prt 0 id , doc (showString ";")])
   SjumpTwo  -> prPrec i 0 (concatD [doc (showString "continue") , doc (showString ";")])
   SjumpThree  -> prPrec i 0 (concatD [doc (showString "break") , doc (showString ";")])
   SjumpFour  -> prPrec i 0 (concatD [doc (showString "return") , doc (showString ";")])
   SjumpFive exp -> prPrec i 0 (concatD [doc (showString "return") , prt 0 exp , doc (showString ";")])


instance Print Exp where
  prt i e = case e of
   Ecomma exp0 exp -> prPrec i 0 (concatD [prt 0 exp0 , doc (showString ",") , prt 2 exp])
   Eassign exp0 assignment_op exp -> prPrec i 2 (concatD [prt 15 exp0 , prt 0 assignment_op , prt 2 exp])
   Econdition exp0 exp1 exp -> prPrec i 3 (concatD [prt 4 exp0 , doc (showString "?") , prt 0 exp1 , doc (showString ":") , prt 3 exp])
   Elor exp0 exp -> prPrec i 4 (concatD [prt 4 exp0 , doc (showString "||") , prt 5 exp])
   Eland exp0 exp -> prPrec i 5 (concatD [prt 5 exp0 , doc (showString "&&") , prt 6 exp])
   Ebitor exp0 exp -> prPrec i 6 (concatD [prt 6 exp0 , doc (showString "|") , prt 7 exp])
   Ebitexor exp0 exp -> prPrec i 7 (concatD [prt 7 exp0 , doc (showString "^") , prt 8 exp])
   Ebitand exp0 exp -> prPrec i 8 (concatD [prt 8 exp0 , doc (showString "&") , prt 9 exp])
   Eeq exp0 exp -> prPrec i 9 (concatD [prt 9 exp0 , doc (showString "==") , prt 10 exp])
   Eneq exp0 exp -> prPrec i 9 (concatD [prt 9 exp0 , doc (showString "!=") , prt 10 exp])
   Elthen exp0 exp -> prPrec i 10 (concatD [prt 10 exp0 , doc (showString "<") , prt 11 exp])
   Egrthen exp0 exp -> prPrec i 10 (concatD [prt 10 exp0 , doc (showString ">") , prt 11 exp])
   Ele exp0 exp -> prPrec i 10 (concatD [prt 10 exp0 , doc (showString "<=") , prt 11 exp])
   Ege exp0 exp -> prPrec i 10 (concatD [prt 10 exp0 , doc (showString ">=") , prt 11 exp])
   Eleft exp0 exp -> prPrec i 11 (concatD [prt 11 exp0 , doc (showString "<<") , prt 12 exp])
   Eright exp0 exp -> prPrec i 11 (concatD [prt 11 exp0 , doc (showString ">>") , prt 12 exp])
   Eplus exp0 exp -> prPrec i 12 (concatD [prt 12 exp0 , doc (showString "+") , prt 13 exp])
   Eminus exp0 exp -> prPrec i 12 (concatD [prt 12 exp0 , doc (showString "-") , prt 13 exp])
   Etimes exp0 exp -> prPrec i 13 (concatD [prt 13 exp0 , doc (showString "*") , prt 14 exp])
   Ediv exp0 exp -> prPrec i 13 (concatD [prt 13 exp0 , doc (showString "/") , prt 14 exp])
   Emod exp0 exp -> prPrec i 13 (concatD [prt 13 exp0 , doc (showString "%") , prt 14 exp])
   Etypeconv type_name exp -> prPrec i 14 (concatD [doc (showString "(") , prt 0 type_name , doc (showString ")") , prt 14 exp])
   Epreinc exp -> prPrec i 15 (concatD [doc (showString "++") , prt 15 exp])
   Epredec exp -> prPrec i 15 (concatD [doc (showString "--") , prt 15 exp])
   Epreop unary_operator exp -> prPrec i 15 (concatD [prt 0 unary_operator , prt 14 exp])
   Ebytesexpr exp -> prPrec i 15 (concatD [doc (showString "sizeof") , prt 15 exp])
   Ebytestype type_name -> prPrec i 15 (concatD [doc (showString "sizeof") , doc (showString "(") , prt 0 type_name , doc (showString ")")])
   Earray exp0 exp -> prPrec i 16 (concatD [prt 16 exp0 , doc (showString "[") , prt 0 exp , doc (showString "]")])
   Efunk exp -> prPrec i 16 (concatD [prt 16 exp , doc (showString "(") , doc (showString ")")])
   Efunkpar exp exps -> prPrec i 16 (concatD [prt 16 exp , doc (showString "(") , prt 2 exps , doc (showString ")")])
   Eselect exp id -> prPrec i 16 (concatD [prt 16 exp , doc (showString ".") , prt 0 id])
   Epoint exp id -> prPrec i 16 (concatD [prt 16 exp , doc (showString "->") , prt 0 id])
   Epostinc exp -> prPrec i 16 (concatD [prt 16 exp , doc (showString "++")])
   Epostdec exp -> prPrec i 16 (concatD [prt 16 exp , doc (showString "--")])
   Evar id -> prPrec i 17 (concatD [prt 0 id])
   Econst constant -> prPrec i 17 (concatD [prt 0 constant])
   Estring str -> prPrec i 17 (concatD [prt 0 str])

  prtList es = case es of
   [x] -> (concatD [prt 2 x])
   x:xs -> (concatD [prt 2 x , doc (showString ",") , prt 2 xs])

instance Print Constant where
  prt i e = case e of
   Efloat d -> prPrec i 0 (concatD [prt 0 d])
   Echar c -> prPrec i 0 (concatD [prt 0 c])
   Eunsigned unsigned -> prPrec i 0 (concatD [prt 0 unsigned])
   Elong long -> prPrec i 0 (concatD [prt 0 long])
   Eunsignlong unsignedlong -> prPrec i 0 (concatD [prt 0 unsignedlong])
   Ehexadec hexadecimal -> prPrec i 0 (concatD [prt 0 hexadecimal])
   Ehexaunsign hexunsigned -> prPrec i 0 (concatD [prt 0 hexunsigned])
   Ehexalong hexlong -> prPrec i 0 (concatD [prt 0 hexlong])
   Ehexaunslong hexunslong -> prPrec i 0 (concatD [prt 0 hexunslong])
   Eoctal octal -> prPrec i 0 (concatD [prt 0 octal])
   Eoctalunsign octalunsigned -> prPrec i 0 (concatD [prt 0 octalunsigned])
   Eoctallong octallong -> prPrec i 0 (concatD [prt 0 octallong])
   Eoctalunslong octalunslong -> prPrec i 0 (concatD [prt 0 octalunslong])
   Ecdouble cdouble -> prPrec i 0 (concatD [prt 0 cdouble])
   Ecfloat cfloat -> prPrec i 0 (concatD [prt 0 cfloat])
   Eclongdouble clongdouble -> prPrec i 0 (concatD [prt 0 clongdouble])
   Eint n -> prPrec i 0 (concatD [prt 0 n])
   Elonger n -> prPrec i 0 (concatD [prt 0 n])
   Edouble d -> prPrec i 0 (concatD [prt 0 d])


instance Print Constant_expression where
  prt i e = case e of
   Especial exp -> prPrec i 0 (concatD [prt 3 exp])


instance Print Unary_operator where
  prt i e = case e of
   Address  -> prPrec i 0 (concatD [doc (showString "&")])
   Indirection  -> prPrec i 0 (concatD [doc (showString "*")])
   Plus  -> prPrec i 0 (concatD [doc (showString "+")])
   Negative  -> prPrec i 0 (concatD [doc (showString "-")])
   Complement  -> prPrec i 0 (concatD [doc (showString "~")])
   Logicalneg  -> prPrec i 0 (concatD [doc (showString "!")])


instance Print Assignment_op where
  prt i e = case e of
   Assign  -> prPrec i 0 (concatD [doc (showString "=")])
   AssignMul  -> prPrec i 0 (concatD [doc (showString "*=")])
   AssignDiv  -> prPrec i 0 (concatD [doc (showString "/=")])
   AssignMod  -> prPrec i 0 (concatD [doc (showString "%=")])
   AssignAdd  -> prPrec i 0 (concatD [doc (showString "+=")])
   AssignSub  -> prPrec i 0 (concatD [doc (showString "-=")])
   AssignLeft  -> prPrec i 0 (concatD [doc (showString "<<=")])
   AssignRight  -> prPrec i 0 (concatD [doc (showString ">>=")])
   AssignAnd  -> prPrec i 0 (concatD [doc (showString "&=")])
   AssignXor  -> prPrec i 0 (concatD [doc (showString "^=")])
   AssignOr  -> prPrec i 0 (concatD [doc (showString "|=")])


