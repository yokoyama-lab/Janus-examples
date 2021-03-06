module SkelC where

-- Haskell module generated by the BNF converter

import AbsC
import ErrM
type Result = Err String

failure :: Show a => a -> Result
failure x = Bad $ "Undefined case: " ++ show x

transIdent :: Ident -> Result
transIdent x = case x of
  Ident str  -> failure x


transUnsigned :: Unsigned -> Result
transUnsigned x = case x of
  Unsigned str  -> failure x


transLong :: Long -> Result
transLong x = case x of
  Long str  -> failure x


transUnsignedLong :: UnsignedLong -> Result
transUnsignedLong x = case x of
  UnsignedLong str  -> failure x


transHexadecimal :: Hexadecimal -> Result
transHexadecimal x = case x of
  Hexadecimal str  -> failure x


transHexUnsigned :: HexUnsigned -> Result
transHexUnsigned x = case x of
  HexUnsigned str  -> failure x


transHexLong :: HexLong -> Result
transHexLong x = case x of
  HexLong str  -> failure x


transHexUnsLong :: HexUnsLong -> Result
transHexUnsLong x = case x of
  HexUnsLong str  -> failure x


transOctal :: Octal -> Result
transOctal x = case x of
  Octal str  -> failure x


transOctalUnsigned :: OctalUnsigned -> Result
transOctalUnsigned x = case x of
  OctalUnsigned str  -> failure x


transOctalLong :: OctalLong -> Result
transOctalLong x = case x of
  OctalLong str  -> failure x


transOctalUnsLong :: OctalUnsLong -> Result
transOctalUnsLong x = case x of
  OctalUnsLong str  -> failure x


transCDouble :: CDouble -> Result
transCDouble x = case x of
  CDouble str  -> failure x


transCFloat :: CFloat -> Result
transCFloat x = case x of
  CFloat str  -> failure x


transCLongDouble :: CLongDouble -> Result
transCLongDouble x = case x of
  CLongDouble str  -> failure x


transProgram :: Program -> Result
transProgram x = case x of
  Progr external_declarations  -> failure x


transExternal_declaration :: External_declaration -> Result
transExternal_declaration x = case x of
  Afunc function_def  -> failure x
  Global dec  -> failure x


transFunction_def :: Function_def -> Result
transFunction_def x = case x of
  OldFunc declaration_specifiers declarator decs compound_stm  -> failure x
  NewFunc declaration_specifiers declarator compound_stm  -> failure x
  OldFuncInt declarator decs compound_stm  -> failure x
  NewFuncInt declarator compound_stm  -> failure x


transDec :: Dec -> Result
transDec x = case x of
  NoDeclarator declaration_specifiers  -> failure x
  Declarators declaration_specifiers init_declarators  -> failure x


transDeclaration_specifier :: Declaration_specifier -> Result
transDeclaration_specifier x = case x of
  Type type_specifier  -> failure x
  Storage storage_class_specifier  -> failure x
  SpecProp type_qualifier  -> failure x


transInit_declarator :: Init_declarator -> Result
transInit_declarator x = case x of
  OnlyDecl declarator  -> failure x
  InitDecl declarator initializer  -> failure x


transType_specifier :: Type_specifier -> Result
transType_specifier x = case x of
  Tvoid  -> failure x
  Tchar  -> failure x
  Tshort  -> failure x
  Tint  -> failure x
  Tlong  -> failure x
  Tfloat  -> failure x
  Tdouble  -> failure x
  Tsigned  -> failure x
  Tunsigned  -> failure x
  Tstruct struct_or_union_spec  -> failure x
  Tenum enum_specifier  -> failure x
  Tname  -> failure x


transStorage_class_specifier :: Storage_class_specifier -> Result
transStorage_class_specifier x = case x of
  MyType  -> failure x
  GlobalPrograms  -> failure x
  LocalProgram  -> failure x
  LocalBlock  -> failure x
  LocalReg  -> failure x


transType_qualifier :: Type_qualifier -> Result
transType_qualifier x = case x of
  Const  -> failure x
  NoOptim  -> failure x


transStruct_or_union_spec :: Struct_or_union_spec -> Result
transStruct_or_union_spec x = case x of
  Tag struct_or_union id struct_decs  -> failure x
  Unique struct_or_union struct_decs  -> failure x
  TagType struct_or_union id  -> failure x


transStruct_or_union :: Struct_or_union -> Result
transStruct_or_union x = case x of
  Struct  -> failure x
  Union  -> failure x


transStruct_dec :: Struct_dec -> Result
transStruct_dec x = case x of
  Structen spec_quals struct_declarators  -> failure x


transSpec_qual :: Spec_qual -> Result
transSpec_qual x = case x of
  TypeSpec type_specifier  -> failure x
  QualSpec type_qualifier  -> failure x


transStruct_declarator :: Struct_declarator -> Result
transStruct_declarator x = case x of
  Decl declarator  -> failure x
  Field constant_expression  -> failure x
  DecField declarator constant_expression  -> failure x


transEnum_specifier :: Enum_specifier -> Result
transEnum_specifier x = case x of
  EnumDec enumerators  -> failure x
  EnumName id enumerators  -> failure x
  EnumVar id  -> failure x


transEnumerator :: Enumerator -> Result
transEnumerator x = case x of
  Plain id  -> failure x
  EnumInit id constant_expression  -> failure x


transDeclarator :: Declarator -> Result
transDeclarator x = case x of
  BeginPointer pointer direct_declarator  -> failure x
  NoPointer direct_declarator  -> failure x


transDirect_declarator :: Direct_declarator -> Result
transDirect_declarator x = case x of
  Name id  -> failure x
  ParenDecl declarator  -> failure x
  InnitArray direct_declarator constant_expression  -> failure x
  Incomplete direct_declarator  -> failure x
  NewFuncDec direct_declarator parameter_type  -> failure x
  OldFuncDef direct_declarator ids  -> failure x
  OldFuncDec direct_declarator  -> failure x


transPointer :: Pointer -> Result
transPointer x = case x of
  Point  -> failure x
  PointQual type_qualifiers  -> failure x
  PointPoint pointer  -> failure x
  PointQualPoint type_qualifiers pointer  -> failure x


transParameter_type :: Parameter_type -> Result
transParameter_type x = case x of
  AllSpec parameter_declarations  -> failure x
  More parameter_declarations  -> failure x


transParameter_declarations :: Parameter_declarations -> Result
transParameter_declarations x = case x of
  ParamDec parameter_declaration  -> failure x
  MoreParamDec parameter_declarations parameter_declaration  -> failure x


transParameter_declaration :: Parameter_declaration -> Result
transParameter_declaration x = case x of
  OnlyType declaration_specifiers  -> failure x
  TypeAndParam declaration_specifiers declarator  -> failure x
  Abstract declaration_specifiers abstract_declarator  -> failure x


transInitializer :: Initializer -> Result
transInitializer x = case x of
  InitExpr exp  -> failure x
  InitListOne initializers  -> failure x
  InitListTwo initializers  -> failure x


transInitializers :: Initializers -> Result
transInitializers x = case x of
  AnInit initializer  -> failure x
  MoreInit initializers initializer  -> failure x


transType_name :: Type_name -> Result
transType_name x = case x of
  PlainType spec_quals  -> failure x
  ExtendedType spec_quals abstract_declarator  -> failure x


transAbstract_declarator :: Abstract_declarator -> Result
transAbstract_declarator x = case x of
  PointerStart pointer  -> failure x
  Advanced dir_abs_dec  -> failure x
  PointAdvanced pointer dir_abs_dec  -> failure x


transDir_abs_dec :: Dir_abs_dec -> Result
transDir_abs_dec x = case x of
  WithinParentes abstract_declarator  -> failure x
  Array  -> failure x
  InitiatedArray constant_expression  -> failure x
  UnInitiated dir_abs_dec  -> failure x
  Initiated dir_abs_dec constant_expression  -> failure x
  OldFunction  -> failure x
  NewFunction parameter_type  -> failure x
  OldFuncExpr dir_abs_dec  -> failure x
  NewFuncExpr dir_abs_dec parameter_type  -> failure x


transStm :: Stm -> Result
transStm x = case x of
  LabelS labeled_stm  -> failure x
  CompS compound_stm  -> failure x
  ExprS expression_stm  -> failure x
  SelS selection_stm  -> failure x
  IterS iter_stm  -> failure x
  JumpS jump_stm  -> failure x


transLabeled_stm :: Labeled_stm -> Result
transLabeled_stm x = case x of
  SlabelOne id stm  -> failure x
  SlabelTwo constant_expression stm  -> failure x
  SlabelThree stm  -> failure x


transCompound_stm :: Compound_stm -> Result
transCompound_stm x = case x of
  ScompOne  -> failure x
  ScompTwo stms  -> failure x
  ScompThree decs  -> failure x
  ScompFour decs stms  -> failure x


transExpression_stm :: Expression_stm -> Result
transExpression_stm x = case x of
  SexprOne  -> failure x
  SexprTwo exp  -> failure x


transSelection_stm :: Selection_stm -> Result
transSelection_stm x = case x of
  SselOne exp stm  -> failure x
  SselTwo exp stm1 stm2  -> failure x
  SselThree exp stm  -> failure x


transIter_stm :: Iter_stm -> Result
transIter_stm x = case x of
  SiterOne exp stm  -> failure x
  SiterTwo stm exp  -> failure x
  SiterThree expression_stm1 expression_stm2 stm3  -> failure x
  SiterFour expression_stm1 expression_stm2 exp3 stm4  -> failure x


transJump_stm :: Jump_stm -> Result
transJump_stm x = case x of
  SjumpOne id  -> failure x
  SjumpTwo  -> failure x
  SjumpThree  -> failure x
  SjumpFour  -> failure x
  SjumpFive exp  -> failure x


transExp :: Exp -> Result
transExp x = case x of
  Ecomma exp1 exp2  -> failure x
  Eassign exp1 assignment_op2 exp3  -> failure x
  Econdition exp1 exp2 exp3  -> failure x
  Elor exp1 exp2  -> failure x
  Eland exp1 exp2  -> failure x
  Ebitor exp1 exp2  -> failure x
  Ebitexor exp1 exp2  -> failure x
  Ebitand exp1 exp2  -> failure x
  Eeq exp1 exp2  -> failure x
  Eneq exp1 exp2  -> failure x
  Elthen exp1 exp2  -> failure x
  Egrthen exp1 exp2  -> failure x
  Ele exp1 exp2  -> failure x
  Ege exp1 exp2  -> failure x
  Eleft exp1 exp2  -> failure x
  Eright exp1 exp2  -> failure x
  Eplus exp1 exp2  -> failure x
  Eminus exp1 exp2  -> failure x
  Etimes exp1 exp2  -> failure x
  Ediv exp1 exp2  -> failure x
  Emod exp1 exp2  -> failure x
  Etypeconv type_name exp  -> failure x
  Epreinc exp  -> failure x
  Epredec exp  -> failure x
  Epreop unary_operator exp  -> failure x
  Ebytesexpr exp  -> failure x
  Ebytestype type_name  -> failure x
  Earray exp1 exp2  -> failure x
  Efunk exp  -> failure x
  Efunkpar exp exps  -> failure x
  Eselect exp id  -> failure x
  Epoint exp id  -> failure x
  Epostinc exp  -> failure x
  Epostdec exp  -> failure x
  Evar id  -> failure x
  Econst constant  -> failure x
  Estring str  -> failure x


transConstant :: Constant -> Result
transConstant x = case x of
  Efloat d  -> failure x
  Echar c  -> failure x
  Eunsigned unsigned  -> failure x
  Elong long  -> failure x
  Eunsignlong unsignedlong  -> failure x
  Ehexadec hexadecimal  -> failure x
  Ehexaunsign hexunsigned  -> failure x
  Ehexalong hexlong  -> failure x
  Ehexaunslong hexunslong  -> failure x
  Eoctal octal  -> failure x
  Eoctalunsign octalunsigned  -> failure x
  Eoctallong octallong  -> failure x
  Eoctalunslong octalunslong  -> failure x
  Ecdouble cdouble  -> failure x
  Ecfloat cfloat  -> failure x
  Eclongdouble clongdouble  -> failure x
  Eint n  -> failure x
  Elonger n  -> failure x
  Edouble d  -> failure x


transConstant_expression :: Constant_expression -> Result
transConstant_expression x = case x of
  Especial exp  -> failure x


transUnary_operator :: Unary_operator -> Result
transUnary_operator x = case x of
  Address  -> failure x
  Indirection  -> failure x
  Plus  -> failure x
  Negative  -> failure x
  Complement  -> failure x
  Logicalneg  -> failure x


transAssignment_op :: Assignment_op -> Result
transAssignment_op x = case x of
  Assign  -> failure x
  AssignMul  -> failure x
  AssignDiv  -> failure x
  AssignMod  -> failure x
  AssignAdd  -> failure x
  AssignSub  -> failure x
  AssignLeft  -> failure x
  AssignRight  -> failure x
  AssignAnd  -> failure x
  AssignXor  -> failure x
  AssignOr  -> failure x



