.PHONY: test
test:
	erlc -o . cell.erl witness.erl port.erl 2>/dev/null
	erl -noshell -eval 'test:run(), halt().'
