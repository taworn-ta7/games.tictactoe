module ttt/client

go 1.17

replace ttt/ttt => ../ttt

require golang.org/x/sys v0.0.0-20220209214540-3681064d5158 // indirect

require (
	github.com/eiannone/keyboard v0.0.0-20200508000154-caf4b762e807
	ttt/ttt v0.0.0-00010101000000-000000000000
)
