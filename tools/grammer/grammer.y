options {
    header_prefix=LIBDARK_SIGMA
    library_name=libdark
    class_prefix=sigma
}

tokens {
    [ \t\n]                     ;
    ,                           COMMA
    :                           COLON
    \<=                         LESS_EQ
    \>=                         GREATER_EQ
    \<                          LESS
    \>                          GREATER
    =                           EQUAL
    \*                          MULTIPLY
    \+                          PLUS
    \-                          MINUS
    private                     PRIVATE
    prove                       PROVE
    \(                          L_BRACKET
    \)                          R_BRACKET
    represent                   REPRESENT
    linear_equation             LINEAR_EQUATION
    range_proof                 RANGE_PROOF
    any                         ANY
    all                         ALL
    version                     VERSION
    \.                          DOT
    [0-9]+                      NUMBER
    [a-zA-Z]+[a-zA-Z0-9_]*      TOKEN
    .                           ;
}

grammar {
program:
	header private prove
    {
        return <root> [ $1, $2, $3 ]
    }
	;
header:
	VERSION version_number
    {
        return $2
    }
	;
version_number:
    NUMBER DOT NUMBER
    {
        return <version> [ $1, $3 ]
    }
    | NUMBER DOT NUMBER DOT NUMBER
    {
        return <version> [ $1, $3, $5 ]
    }
    ;

private:
    PRIVATE COLON private_values
    {
        return $3
    }
    ;
private_values:
    private_values COMMA private_value
    {
        return $1.add($3)
    }
    | private_value
    {
        return <private_section> [ $1 ]
    }
    ;
private_value:
    TOKEN
    {
        return <private_value> : $1
    }
    ;

prove:
    PROVE COLON statements
    {
        return <prove_section> from $3
    }
    | PROVE COLON
    {
        return <prove_section>
    }
    ;
statements:
    statements COMMA statement
    {
        return $1.add($3)
    }
    | statement
    {
        return <template> [ $1 ]
    }
    ;
statement:
    represent
    {
        return $1
    }
    | linear_equation
    {
        return $1
    }
    | range_proof
    {
        return $1
    }
    | any
    {
        return $1
    }
    | all
    {
        return $1
    }
    ;

represent:
    REPRESENT L_BRACKET equality_expression R_BRACKET
    {
        return <represent> [ $3 ]
    }
    ;

linear_equation:
    LINEAR_EQUATION L_BRACKET equality_expression R_BRACKET
    {
        return <linear_equation> [ $3 ]
    }
    ;

range_proof:
    RANGE_PROOF L_BRACKET range_expression R_BRACKET
    {
        return <range_proof> [ $3 ]
    }
    ;

equality_expression:
    expression EQUAL expression
    {
        return <equal> [ $1, $3 ]
    }
    ;

range_expression:
    expression LESS_EQ expression
    {
        return <less_equal> [ $1, $3 ]
    }
    | expression GREATER_EQ expression
    {
        return <greater_equal> [ $1, $3 ]
    }
    | expression LESS expression
    {
        return <less> [ $1, $3 ]
    }
    | expression GREATER expression
    {
        return <greater> [ $1, $3 ]
    }
    ;

expression:
    expression PLUS item
    {
        return $1.add($3)
    }
    | expression MINUS item
    {
        negative = <negative> [ $3 ]
        return $1.add(negative)
    }
    | item
    {
        return <sum> [ $1 ]
    }
    ;

item:
    TOKEN TOKEN
    {
        return <multiply> [
            <variable> : $1,
            <variable> : $2
        ]
    }
    | TOKEN MULTIPLY TOKEN
    {
        return <multiply> [
            <variable> : $1,
            <variable> : $2
        ]
    }
    | TOKEN
    {
        return <variable> : $1
    }
    | NUMBER TOKEN
    {
        return <multiply> [
            <number> : $1,
            <variable> : $2
        ]
    }
    | NUMBER
    {
        return <number> : $1
    }
    ;

any:
    ANY L_BRACKET statements R_BRACKET
    {
        return <any> from $3
    }
    ;

all:
    ALL L_BRACKET statements R_BRACKET
    {
        return <all> from $3
    }
    ;
}

