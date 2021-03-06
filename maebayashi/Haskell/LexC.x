-- -*- haskell -*-
-- This Alex file was machine-generated by the BNF converter
{
{-# OPTIONS -fno-warn-incomplete-patterns #-}
{-# OPTIONS_GHC -w #-}
module LexC where



import qualified Data.Bits
import Data.Word (Word8)
}


$l = [a-zA-Z\192 - \255] # [\215 \247]    -- isolatin1 letter FIXME
$c = [A-Z\192-\221] # [\215]    -- capital isolatin1 letter FIXME
$s = [a-z\222-\255] # [\247]    -- small isolatin1 letter FIXME
$d = [0-9]                -- digit
$i = [$l $d _ ']          -- identifier character
$u = [\0-\255]          -- universal: any character

@rsyms =    -- symbols and non-identifier-like reserved words
   \; | \, | \= | \{ | \} | \: | \( | \) | \[ | \] | \* | \. \. \. | \? | \| \| | \& \& | \| | \^ | \& | \= \= | \! \= | \< | \> | \< \= | \> \= | \< \< | \> \> | \+ | \- | \/ | \% | \+ \+ | \- \- | \. | \- \> | \~ | \! | \* \= | \/ \= | \% \= | \+ \= | \- \= | \< \< \= | \> \> \= | \& \= | \^ \= | \| \=

:-
"//" [.]* ; -- Toss single line comments
"#" [.]* ; -- Toss single line comments
"/*" ([$u # \*] | \* [$u # \/])* ("*")+ "/" ; 

$white+ ;
@rsyms { tok (\p s -> PT p (eitherResIdent (TV . share) s)) }
[1 2 3 4 5 6 7 8 9]$d * (u | U) { tok (\p s -> PT p (eitherResIdent (T_Unsigned . share) s)) }
[1 2 3 4 5 6 7 8 9]$d * (l | L) { tok (\p s -> PT p (eitherResIdent (T_Long . share) s)) }
[1 2 3 4 5 6 7 8 9]$d * (u l | U L) { tok (\p s -> PT p (eitherResIdent (T_UnsignedLong . share) s)) }
0 (x | X)($d | [a b c d e f]| [A B C D E F]) + { tok (\p s -> PT p (eitherResIdent (T_Hexadecimal . share) s)) }
0 (x | X)($d | [a b c d e f]| [A B C D E F]) + (u | U) { tok (\p s -> PT p (eitherResIdent (T_HexUnsigned . share) s)) }
0 (x | X)($d | [a b c d e f]| [A B C D E F]) + (l | L) { tok (\p s -> PT p (eitherResIdent (T_HexLong . share) s)) }
0 (x | X)($d | [a b c d e f]| [A B C D E F]) + (u l | U L) { tok (\p s -> PT p (eitherResIdent (T_HexUnsLong . share) s)) }
0 [0 1 2 3 4 5 6 7]* { tok (\p s -> PT p (eitherResIdent (T_Octal . share) s)) }
0 [0 1 2 3 4 5 6 7]* (u | U) { tok (\p s -> PT p (eitherResIdent (T_OctalUnsigned . share) s)) }
0 [0 1 2 3 4 5 6 7]* (l | L) { tok (\p s -> PT p (eitherResIdent (T_OctalLong . share) s)) }
0 [0 1 2 3 4 5 6 7]* (u l | U L) { tok (\p s -> PT p (eitherResIdent (T_OctalUnsLong . share) s)) }
($d + \. | \. $d +)((e | E)\- ? $d +)? | $d + (e | E)\- ? $d + | $d + \. $d + E \- ? $d + { tok (\p s -> PT p (eitherResIdent (T_CDouble . share) s)) }
($d + \. $d + | $d + \. | \. $d +)((e | E)\- ? $d +)? (f | F)| $d + (e | E)\- ? $d + (f | F) { tok (\p s -> PT p (eitherResIdent (T_CFloat . share) s)) }
($d + \. $d + | $d + \. | \. $d +)((e | E)\- ? $d +)? (l | L)| $d + (e | E)\- ? $d + (l | L) { tok (\p s -> PT p (eitherResIdent (T_CLongDouble . share) s)) }

$l $i*   { tok (\p s -> PT p (eitherResIdent (TV . share) s)) }
\" ([$u # [\" \\ \n]] | (\\ (\" | \\ | \' | n | t)))* \"{ tok (\p s -> PT p (TL $ share $ unescapeInitTail s)) }
\' ($u # [\' \\] | \\ [\\ \' n t]) \'  { tok (\p s -> PT p (TC $ share s))  }
$d+      { tok (\p s -> PT p (TI $ share s))    }
$d+ \. $d+ (e (\-)? $d+)? { tok (\p s -> PT p (TD $ share s)) }

{

tok f p s = f p s

share :: String -> String
share = id

data Tok =
   TS !String !Int    -- reserved words and symbols
 | TL !String         -- string literals
 | TI !String         -- integer literals
 | TV !String         -- identifiers
 | TD !String         -- double precision float literals
 | TC !String         -- character literals
 | T_Unsigned !String
 | T_Long !String
 | T_UnsignedLong !String
 | T_Hexadecimal !String
 | T_HexUnsigned !String
 | T_HexLong !String
 | T_HexUnsLong !String
 | T_Octal !String
 | T_OctalUnsigned !String
 | T_OctalLong !String
 | T_OctalUnsLong !String
 | T_CDouble !String
 | T_CFloat !String
 | T_CLongDouble !String

 deriving (Eq,Show,Ord)

data Token = 
   PT  Posn Tok
 | Err Posn
  deriving (Eq,Show,Ord)

tokenPos (PT (Pn _ l _) _ :_) = "line " ++ show l
tokenPos (Err (Pn _ l _) :_) = "line " ++ show l
tokenPos _ = "end of file"

tokenPosn (PT p _) = p
tokenPosn (Err p) = p
tokenLineCol = posLineCol . tokenPosn
posLineCol (Pn _ l c) = (l,c)
mkPosToken t@(PT p _) = (posLineCol p, prToken t)

prToken t = case t of
  PT _ (TS s _) -> s
  PT _ (TL s)   -> s
  PT _ (TI s)   -> s
  PT _ (TV s)   -> s
  PT _ (TD s)   -> s
  PT _ (TC s)   -> s
  PT _ (T_Unsigned s) -> s
  PT _ (T_Long s) -> s
  PT _ (T_UnsignedLong s) -> s
  PT _ (T_Hexadecimal s) -> s
  PT _ (T_HexUnsigned s) -> s
  PT _ (T_HexLong s) -> s
  PT _ (T_HexUnsLong s) -> s
  PT _ (T_Octal s) -> s
  PT _ (T_OctalUnsigned s) -> s
  PT _ (T_OctalLong s) -> s
  PT _ (T_OctalUnsLong s) -> s
  PT _ (T_CDouble s) -> s
  PT _ (T_CFloat s) -> s
  PT _ (T_CLongDouble s) -> s


data BTree = N | B String Tok BTree BTree deriving (Show)

eitherResIdent :: (String -> Tok) -> String -> Tok
eitherResIdent tv s = treeFind resWords
  where
  treeFind N = tv s
  treeFind (B a t left right) | s < a  = treeFind left
                              | s > a  = treeFind right
                              | s == a = t

resWords = b "^" 40 (b "." 20 (b "*" 10 (b "&" 5 (b "%" 3 (b "!=" 2 (b "!" 1 N N) N) (b "%=" 4 N N)) (b "(" 8 (b "&=" 7 (b "&&" 6 N N) N) (b ")" 9 N N))) (b "," 15 (b "++" 13 (b "+" 12 (b "*=" 11 N N) N) (b "+=" 14 N N)) (b "-=" 18 (b "--" 17 (b "-" 16 N N) N) (b "->" 19 N N)))) (b "=" 30 (b ";" 25 (b "/=" 23 (b "/" 22 (b "..." 21 N N) N) (b ":" 24 N N)) (b "<<=" 28 (b "<<" 27 (b "<" 26 N N) N) (b "<=" 29 N N))) (b ">>=" 35 (b ">=" 33 (b ">" 32 (b "==" 31 N N) N) (b ">>" 34 N N)) (b "[" 38 (b "Typedef_name" 37 (b "?" 36 N N) N) (b "]" 39 N N))))) (b "register" 60 (b "double" 50 (b "char" 45 (b "break" 43 (b "auto" 42 (b "^=" 41 N N) N) (b "case" 44 N N)) (b "default" 48 (b "continue" 47 (b "const" 46 N N) N) (b "do" 49 N N))) (b "for" 55 (b "extern" 53 (b "enum" 52 (b "else" 51 N N) N) (b "float" 54 N N)) (b "int" 58 (b "if" 57 (b "goto" 56 N N) N) (b "long" 59 N N)))) (b "unsigned" 70 (b "static" 65 (b "signed" 63 (b "short" 62 (b "return" 61 N N) N) (b "sizeof" 64 N N)) (b "typedef" 68 (b "switch" 67 (b "struct" 66 N N) N) (b "union" 69 N N))) (b "|" 75 (b "while" 73 (b "volatile" 72 (b "void" 71 N N) N) (b "{" 74 N N)) (b "}" 78 (b "||" 77 (b "|=" 76 N N) N) (b "~" 79 N N)))))
   where b s n = let bs = id s
                  in B bs (TS bs n)

unescapeInitTail :: String -> String
unescapeInitTail = id . unesc . tail . id where
  unesc s = case s of
    '\\':c:cs | elem c ['\"', '\\', '\''] -> c : unesc cs
    '\\':'n':cs  -> '\n' : unesc cs
    '\\':'t':cs  -> '\t' : unesc cs
    '"':[]    -> []
    c:cs      -> c : unesc cs
    _         -> []

-------------------------------------------------------------------
-- Alex wrapper code.
-- A modified "posn" wrapper.
-------------------------------------------------------------------

data Posn = Pn !Int !Int !Int
      deriving (Eq, Show,Ord)

alexStartPos :: Posn
alexStartPos = Pn 0 1 1

alexMove :: Posn -> Char -> Posn
alexMove (Pn a l c) '\t' = Pn (a+1)  l     (((c+7) `div` 8)*8+1)
alexMove (Pn a l c) '\n' = Pn (a+1) (l+1)   1
alexMove (Pn a l c) _    = Pn (a+1)  l     (c+1)

type Byte = Word8

type AlexInput = (Posn,     -- current position,
                  Char,     -- previous char
                  [Byte],   -- pending bytes on the current char
                  String)   -- current input string

tokens :: String -> [Token]
tokens str = go (alexStartPos, '\n', [], str)
    where
      go :: AlexInput -> [Token]
      go inp@(pos, _, _, str) =
               case alexScan inp 0 of
                AlexEOF                   -> []
                AlexError (pos, _, _, _)  -> [Err pos]
                AlexSkip  inp' len        -> go inp'
                AlexToken inp' len act    -> act pos (take len str) : (go inp')

alexGetByte :: AlexInput -> Maybe (Byte,AlexInput)
alexGetByte (p, c, (b:bs), s) = Just (b, (p, c, bs, s))
alexGetByte (p, _, [], s) =
  case  s of
    []  -> Nothing
    (c:s) ->
             let p'     = alexMove p c
                 (b:bs) = utf8Encode c
              in p' `seq` Just (b, (p', c, bs, s))

alexInputPrevChar :: AlexInput -> Char
alexInputPrevChar (p, c, bs, s) = c

  -- | Encode a Haskell String to a list of Word8 values, in UTF8 format.
utf8Encode :: Char -> [Word8]
utf8Encode = map fromIntegral . go . ord
 where
  go oc
   | oc <= 0x7f       = [oc]

   | oc <= 0x7ff      = [ 0xc0 + (oc `Data.Bits.shiftR` 6)
                        , 0x80 + oc Data.Bits..&. 0x3f
                        ]

   | oc <= 0xffff     = [ 0xe0 + (oc `Data.Bits.shiftR` 12)
                        , 0x80 + ((oc `Data.Bits.shiftR` 6) Data.Bits..&. 0x3f)
                        , 0x80 + oc Data.Bits..&. 0x3f
                        ]
   | otherwise        = [ 0xf0 + (oc `Data.Bits.shiftR` 18)
                        , 0x80 + ((oc `Data.Bits.shiftR` 12) Data.Bits..&. 0x3f)
                        , 0x80 + ((oc `Data.Bits.shiftR` 6) Data.Bits..&. 0x3f)
                        , 0x80 + oc Data.Bits..&. 0x3f
                        ]
}
