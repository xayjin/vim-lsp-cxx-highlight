" Text properties

let s:has_reltime = has('reltime')

function! lsp_cxx_hl#textprop#syn_prop_type_add(name, resolved_hl_group) abort
    call prop_type_add(a:name, {
                \ 'highlight': a:resolved_hl_group,
                \ 'start_incl': 1,
                \ 'end_incl': 0,
                \ 'priority': g:lsp_cxx_hl_syntax_priority
                \ })
endfunction

function! lsp_cxx_hl#textprop#gen_prop_id() abort
    if s:has_reltime
        return xor(reltime()[0], line('.') * col('.') * reltime()[1])
    else
        return xor(localtime(), line('.') * col('.'))
    endif
endfunction

function! lsp_cxx_hl#textprop#lsrange2prop(range) abort
    return s:range_to_matches(
                \ a:range['start']['line'] + 1,
                \ a:range['start']['character'] + 1,
                \ a:range['end']['line'] + 1,
                \ a:range['end']['character'] + 1
                \ )
endfunction

function! lsp_cxx_hl#textprop#offsets2prop(offsets) abort
    let l:s_byte = a:offsets['L'] + 1
    let l:e_byte = a:offsets['R'] + 1
    let l:s_line = byte2line(l:s_byte)
    let l:e_line = byte2line(l:e_byte)

    return s:range_to_matches(
                \ l:s_line,
                \ l:s_byte - line2byte(l:s_line) + 1,
                \ l:e_line,
                \ l:e_byte - line2byte(l:e_line) + 1
                \ )
endfunction

function! s:range_to_matches(s_line, s_char, e_line, e_char) abort
    let l:prop_dict = { 'end_col': a:e_char }

    let l:s_line = a:s_line < 1 ? 1 : a:s_line
    let l:e_line = a:e_line > line('$') ? line('$') : a:e_line

    if l:s_line != l:e_line
        let l:prop_dict['end_lnum'] = l:e_line
    endif

    return [l:s_line, a:s_char, l:prop_dict]
endfunction
