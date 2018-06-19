MESA_PROTO=$(GOPATH)/src/mesa.ac.st/mrpc/proto/mesa

gen:
	@swift package generate-xcodeproj

format:
	@swiftformat ./ \
	--indent tabs \
	--allman false \
	--wraparguments beforefirst \
	--wrapelements beforefirst \
	--exponentcase lowercase \
	--stripunusedargs closure-only \
	--self insert \
	--header strip \
	--hexliteralcase uppercase \
	--empty void \
	--ranges nospace \
	--trimwhitespace nonblank-lines \
	--linebreaks lf \
	--commas always \
	--comments ignore \
	--ifdef noindent \
	--patternlet inline \
	--semicolons inline \
	--disable "consecutiveBlankLines,redundantReturn,spaceAroundOperators,unusedArguments,sortedImports,redundantSelf"

test:
	@swift test
	
release: format
	@swift build --configuration=release -Xswiftc -static-stdlib