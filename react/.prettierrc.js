module.exports = {
	printWidth: 128, // 80(default)
	tabWith: 4, // 2(default)
	useTabs: true, // false(default)
	semi: true, // true(default)
	singleQuote: false, // false(default)
	trailingComma: "all", // es5(default), none, all
	bracketSpacing: true, // true(default)
	bracketSameLine: false, // false(default)
	arrowParens: "always", // always(default), avoid
	proseWrap: "never", // preserve(default), always, never
	endOfLine: "lf", // lf(default), crlf, cr, auto
	singleAttributePerLine: false, // false(default)
	overrides: [
		{
			files: ".prettierrc",
			options: {
				parser: "json",
			},
		},
		{
			files: "document.ejs",
			options: {
				parser: "html",
			},
		},
	],
};
