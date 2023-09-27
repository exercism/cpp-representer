from pygments import highlight
from pygments.lexers import CppLexer
from pygments.formatters import NullFormatter
from pygments.token import Comment
from pygments.token import Name
from pygments.token import Token
from pygments.token import Whitespace
from pygments.token import Keyword
from pygments.filter import simplefilter
from pygments.filter import Filter

import json
import sys

from argparse import ArgumentParser

REPRESENTER_VERSION = 1

class Representer:
    def __init__(self, input_dir, output_dir):
        self.input_dir = input_dir
        self.meta_config_file = input_dir + "/.meta/config.json"

        self.output_dir = output_dir
        self.error_file = output_dir +  "/.expect-error"
        self.representation_file = output_dir +  "/representation.txt"
        self.version_file = output_dir +  "/representation.json"
        self.mapping_file = output_dir + "/mapping.json"

    def abort_and_write_error(self, error_msg):
            with open(self.error_file, 'w') as f:
                print(error_msg, file=f)
                sys.exit(1)

    def make_representation(self):
        # Read solution files:
        try:
            solution_file_names = []
            with open(self.meta_config_file, 'r') as f:
                parsed = json.load(f)  # load, not loads
                solution_file_names = parsed["files"]["solution"]
            self.code = ""
            for fname in solution_file_names:
                with open(self.input_dir + "/" + fname, 'r') as f:
                    self.code += f.read() + "\n"
        except:
                self.abort_and_write_error("Cannot open solution files")


        @simplefilter
        def remove_comments(self, lexer, stream, options):
            for ttype, value in stream:
                for ttype, value in stream:
                    if ttype in Comment:  # [Comment.Multiline, Comment.Single]:
                        continue
                    yield ttype, value

        @simplefilter
        def normalize_whitespace(self, lexer, stream, options):
            for ttype, value in stream:
                for ttype, value in stream:
                    if ttype in Whitespace:
                        continue
                    yield ttype, value

        class Normalize_identifiers(Filter):

            def __init__(self, replacements):
                Filter.__init__(self)
                self.replacements = replacements

            def filter(self, lexer, stream):
                for ttype, value in stream:
                    for ttype, value in stream:
                        if ttype in Name:
                            if value == "std":
                                ttype, value = next(stream)
                                if ttype is Token.Operator and value == ":":
                                    ttype, value = next(stream)
                                    if ttype is Token.Operator and value == ":":
                                        ttype, value = next(stream)
                                        yield Keyword.Reserved, "std::" + value
                            else:
                                if value in replacements:
                                    ph = replacements[value]
                                else:
                                    ph = "PLACEHOLDER_" + \
                                        str(len(replacements) + 1)
                                    replacements[value] = ph
                                yield ttype,  ph
                        else:
                            yield ttype, value

        replacements = {}

        lexer = CppLexer(stripall=True)
        lexer.add_filter(remove_comments())
        lexer.add_filter(Normalize_identifiers(replacements))
        lexer.add_filter(normalize_whitespace())
        formatter = NullFormatter()

        # Write files

        with open(self.representation_file, "w") as f:
            print(highlight(self.code, lexer, formatter).strip(), end='', file=f)

        mapping = {value: key for key, value in replacements.items()}
        with open(self.mapping_file, 'w', encoding='utf-8') as f:
            json.dump(mapping, f, ensure_ascii=False, separators=(',', ':'))

        with open(self.version_file, 'w', encoding='utf-8') as f:
            json.dump({"version": REPRESENTER_VERSION}, f, ensure_ascii=False, separators=(',', ':'))


def main():
    parser = ArgumentParser(
        description="Produce a normalized representation of a Cpp solution."
    )

    parser.add_argument("input_dir")
    parser.add_argument("output_dir")

    args = parser.parse_args()

    Representer(args.input_dir, args.output_dir).make_representation()


if __name__ == "__main__":
    main()
