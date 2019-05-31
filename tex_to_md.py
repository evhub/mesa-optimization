from undebt.pattern.util import (
    tokens_as_dict,
    tokens_as_list,
    attach,
)
from undebt.pyparsing import (
    Literal,
    SkipTo,
    OneOrMore,
    originalTextFor,
)
from undebt.pattern.common import (
    BRACES,
    BRACKETS,
    NL,
    ANY_CHAR,
    NUM,
)
from undebt.cmd.logic import (
    create_find_and_replace,
    parse_grammar,
    _transform_results,
)


# util:
REST_OF_LINE = originalTextFor(ANY_CHAR + SkipTo(NL) + NL)

@tokens_as_list(assert_len=1)
def trim(tokens):
    return tokens[0][1:-1]

BRACES_TEXT = attach(BRACES, trim)

NUM_TEXT = originalTextFor(NUM)


# setup:
patterns_list = []


# section:
section_grammar = (
    Literal("\\section") + BRACES_TEXT("name") + NL
    + Literal("\\label{sec:") + NUM_TEXT("num") + Literal("}") + NL
    + Literal("\\cftchapterprecistoc") + BRACES + NL
)

@tokens_as_dict(assert_keys=("name", "num"))
def section_replace(tokens):
    return "&nbsp;\n\n## " + tokens["name"] + "\n"

patterns_list.append((section_grammar, section_replace))


# subsection:
subsection_grammar = (
    Literal("\\subsection") + BRACES_TEXT("name") + NL
    + Literal("\\label{sec:") + NUM_TEXT("num") + Literal("}") + NL
    + Literal("\\cftchapterprecistoc") + BRACES + NL
)

@tokens_as_dict(assert_keys=("name", "num"))
def subsection_replace(tokens):
    return "## " + tokens["num"] + ". " + tokens["name"] + "\n"

patterns_list.append((subsection_grammar, subsection_replace))


# ital:
ital_grammar = (
    Literal("\\textit") + BRACES_TEXT("text")
)

@tokens_as_dict(assert_keys=("text",))
def ital_replace(tokens):
    return "_" + tokens["text"] + "_"

patterns_list.append((ital_grammar, ital_replace))


# bf:
bf_grammar = (
    Literal("\\textbf") + BRACES_TEXT("text")
)

@tokens_as_dict(assert_keys=("text",))
def bf_replace(tokens):
    return "**" + tokens["text"] + "**"

patterns_list.append((bf_grammar, bf_replace))


# cite:
cite_grammar = (
    Literal("\\cite") + BRACES_TEXT("cite")
)

@tokens_as_dict(assert_keys=("cite",))
def cite_replace(tokens):
    return "[(TODO:" + tokens["cite"] + ")](https://intelligence.org/learned-optimization#bibliography)"

patterns_list.append((cite_grammar, cite_replace))


# footnote:
footnote_grammar = (
    Literal("\\footnote") + BRACES_TEXT("footnote")
    + REST_OF_LINE("text")
)

global footnotes_seen
footnotes_seen = 0

@tokens_as_dict(assert_keys=("footnote", "text"))
def footnote_replace(tokens):
    global footnotes_seen
    footnotes_seen += 1
    return (
        "[^" + str(footnotes_seen) + "] "
        + tokens["text"] + "\n"
        + "[^" + str(footnotes_seen) + "]: "
        + tokens["footnote"] + "\n\n"
    )

patterns_list.append((footnote_grammar, footnote_replace))


# enumerate:
enumerate_grammar = (
    Literal("\\begin{enumerate}").suppress() + NL.suppress()
    + OneOrMore(Literal("\\item").suppress() + REST_OF_LINE)
    + Literal("\\end{enumerate}").suppress()
)

@tokens_as_list()
def enumerate_replace(tokens):
    out = "\n"
    for i, item in enumerate(tokens):
        out += str(i + 1) + "." + item
    return out

patterns_list.append((enumerate_grammar, enumerate_replace))


# itemize:
itemize_grammar = (
    Literal("\\begin{itemize}").suppress() + NL.suppress()
    + OneOrMore(Literal("\\item").suppress() + REST_OF_LINE)
    + Literal("\\end{itemize}").suppress()
)

@tokens_as_list()
def itemize_replace(tokens):
    out = ""
    for item in tokens:
        out += "-" + item
    return out

patterns_list.append((itemize_grammar, itemize_replace))


# cref sec:
cref_sec_grammar = (
    Literal("\\cref{sec:") + NUM_TEXT("num") + Literal("}")
)

@tokens_as_dict(assert_keys=("num",))
def cref_sec_replace(tokens):
    return "post " + tokens["num"] + " (TODO)"

patterns_list.append((cref_sec_grammar, cref_sec_replace))


# Cref sec:
Cref_sec_grammar = (
    Literal("\\Cref{sec:") + NUM_TEXT("num") + Literal("}")
)

@tokens_as_dict(assert_keys=("num",))
def Cref_sec_replace(tokens):
    return "Post " + tokens["num"] + " (TODO)"

patterns_list.append((Cref_sec_grammar, Cref_sec_replace))


# cref fig:
cref_fig_grammar = (
    Literal("\\cref{fig:") + NUM_TEXT("num") + Literal("}")
)

@tokens_as_dict(assert_keys=("num",))
def cref_fig_replace(tokens):
    return "figure " + tokens["num"]

patterns_list.append((cref_fig_grammar, cref_fig_replace))


# Cref fig:
Cref_fig_grammar = (
    Literal("\\Cref{fig:") + NUM_TEXT("num") + Literal("}")
)

@tokens_as_dict(assert_keys=("num",))
def Cref_fig_replace(tokens):
    return "Figure " + tokens["num"]

patterns_list.append((Cref_fig_grammar, Cref_fig_replace))


# figure:
figure_grammar = (
    Literal("\\begin{figure}") + BRACKETS + NL
    + Literal("\\centering") + NL
    + Literal("\\includegraphics") + BRACKETS + BRACES_TEXT("image") + NL
    + Literal("\\caption") + BRACES_TEXT("caption") + NL
    + Literal("\\label{fig:") + NUM_TEXT("num") + Literal("}") + NL
    + Literal("\\end{figure}")
)

@tokens_as_dict(assert_keys=("image", "caption", "num"))
def figure_replace(tokens):
    return (
        "![](TODO:" + tokens["image"] + ")\n\n"
        + "**Figure " + tokens["num"]
        + ".** _" + tokens["caption"] + "_"
    )

patterns_list.append((figure_grammar, figure_replace))


# dash:
dash_grammar = Literal("---")

def dash_replace(tokens):
    return "—"

patterns_list.append((dash_grammar, dash_replace))


# open quote:
open_quote_grammar = Literal("``")

def open_quote_replace(tokens):
    return "“"

patterns_list.append((open_quote_grammar, open_quote_replace))


# close quote:
close_quote_grammar = Literal("''")

def close_quote_replace(tokens):
    return "”"

patterns_list.append((close_quote_grammar, close_quote_replace))


# paper:
paper_grammar = Literal("paper")

def paper_replace(tokens):
    return "sequence (TODO)"

patterns_list.append((paper_grammar, paper_replace))


# newline artifacts:
nl_artifact_grammar = Literal("\n\n\n")

def nl_artifact_replace(tokens):
    return "\n\n"

patterns_list.append((nl_artifact_grammar, nl_artifact_replace))


# main:
def main(filename):
    with open(filename, "tr+", encoding="utf-8") as fp:
        text = fp.read()

        for i, (grammar, replace) in enumerate(patterns_list):
            print("running pattern {}...".format(replace.__name__[:-len("_replace")]))

            # keep running grammar until it stops producing results
            j = 0
            while True:
                print("\tpass {}...".format(j + 1))
                j += 1
                find_and_replace = create_find_and_replace(grammar, replace)
                results = parse_grammar(find_and_replace, text)
                if not results:
                    break
                else:
                    text = _transform_results(results, text)

        fp.seek(0)
        fp.truncate()
        fp.write(text)

if __name__ == "__main__":
    main("./post1.md")
