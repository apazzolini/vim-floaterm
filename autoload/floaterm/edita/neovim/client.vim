let s:repo = fnamemodify(expand('<sfile>'), ':p:h:h:h:h:h')

function! floaterm#edita#neovim#client#open() abort
  let server = ($NVIM != '') ? $NVIM : $NVIM_LISTEN_ADDRESS
  let mode = floaterm#edita#neovim#util#mode(server)
  let ch = sockconnect(mode, server, { 'rpc': 1 })
  let target = escape(fnamemodify(argv()[0], ':p'), ' \')
  let client = escape(serverstart(), ' \')
  call rpcrequest(ch, 'nvim_command', printf(
        \ 'call floaterm#edita#neovim#editor#open("%s", "%s", "%s")',
        \ target,
        \ client,
        \ (len(argv()) == 1 || argv()[1] == "1") ? 0 : argv()[1],
        \))
endfunction

function! floaterm#edita#neovim#client#EDITOR() abort
  let args = [
        \ shellescape(v:progpath),
        \ '--headless',
        \ '--clean',
        \ '--noplugin',
        \ '-n',
        \ '-R',
        \]
  let cmds = [
        \ printf('set runtimepath^=%s', fnameescape(s:repo)),
        \ 'call floaterm#edita#neovim#client#open()'
        \]
  call map(cmds, { -> printf('-c %s', shellescape(v:val)) })
  return join(args + cmds)
endfunction


