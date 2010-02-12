open Asm;;
open Common;;

(* Mach-O writer. *)

let (cpu_arch_abi64:int64) = 0x01000000L
;;

let (mh_magic:int64) = 0xfeedfaceL
;;

let cpu_subtype_intel (f:int64) (m:int64) : int64 =
  Int64.add f (Int64.shift_left m 4)
;;

type cpu_type =
    (* Maybe support more later. *)
    CPU_TYPE_X86
  | CPU_TYPE_X86_64
  | CPU_TYPE_ARM
  | CPU_TYPE_POWERPC
;;

type cpu_subtype =
    (* Maybe support more later. *)
    CPU_SUBTYPE_X86_ALL
  | CPU_SUBTYPE_X86_64_ALL
  | CPU_SUBTYPE_ARM_ALL
  | CPU_SUBTYPE_POWERPC_ALL
;;

type file_type =
    MH_OBJECT
  | MH_EXECUTE
  | MH_FVMLIB
  | MH_CORE
  | MH_PRELOAD
  | MH_DYLIB
  | MH_DYLINKER
  | MH_BUNDLE
  | MH_DYLIB_STUB
  | MH_DSYM
;;

let file_type_code (ft:file_type) : int64 =
  match ft with
      MH_OBJECT ->0x1L      (* object *)
    | MH_EXECUTE -> 0x2L    (* executable *)
    | MH_FVMLIB -> 0x3L     (* fixed-VM shared lib *)
    | MH_CORE -> 0x4L       (* core *)
    | MH_PRELOAD -> 0x5L    (* preloaded executable *)
    | MH_DYLIB -> 0x6L      (* dynamic lib *)
    | MH_DYLINKER -> 0x7L   (* dynamic linker *)
    | MH_BUNDLE -> 0x8L     (* bundle *)
    | MH_DYLIB_STUB -> 0x9L (* shared lib stub *)
    | MH_DSYM -> 0xaL       (* debuginfo only *)
;;

type file_flag =
    MH_NOUNDEFS
  | MH_INCRLINK
  | MH_DYLDLINK
  | MH_BINDATLOAD
  | MH_PREBOUND
  | MH_SPLIT_SEGS
  | MH_LAZY_INIT
  | MH_TWOLEVEL
  | MH_FORCE_FLAT
  | MH_NOMULTIDEFS
  | MH_NOFIXPREBINDING
  | MH_PREBINDABLE
  | MH_ALLMODSBOUND
  | MH_SUBSECTIONS_VIA_SYMBOLS
  | MH_CANONICAL
  | MH_WEAK_DEFINES
  | MH_BINDS_TO_WEAK
  | MH_ALLOW_STACK_EXECUTION
  | MH_ROOT_SAFE
  | MH_SETUID_SAFE
  | MH_NO_REEXPORTED_DYLIBS
  | MH_PIE
;;

let file_flag_code (ff:file_flag) : int64 =
  match ff with
      MH_NOUNDEFS -> 0x1L
    | MH_INCRLINK -> 0x2L
    | MH_DYLDLINK -> 0x4L
    | MH_BINDATLOAD -> 0x8L
    | MH_PREBOUND -> 0x10L
    | MH_SPLIT_SEGS -> 0x20L
    | MH_LAZY_INIT -> 0x40L
    | MH_TWOLEVEL -> 0x80L
    | MH_FORCE_FLAT -> 0x100L
    | MH_NOMULTIDEFS -> 0x200L
    | MH_NOFIXPREBINDING -> 0x400L
    | MH_PREBINDABLE -> 0x800L
    | MH_ALLMODSBOUND -> 0x1000L
    | MH_SUBSECTIONS_VIA_SYMBOLS -> 0x2000L
    | MH_CANONICAL -> 0x4000L
    | MH_WEAK_DEFINES -> 0x8000L
    | MH_BINDS_TO_WEAK -> 0x10000L
    | MH_ALLOW_STACK_EXECUTION -> 0x20000L
    | MH_ROOT_SAFE -> 0x40000L
    | MH_SETUID_SAFE -> 0x80000L
    | MH_NO_REEXPORTED_DYLIBS -> 0x100000L
    | MH_PIE -> 0x200000L
;;


type vm_prot =
    VM_PROT_NONE
  | VM_PROT_READ
  | VM_PROT_WRITE
  | VM_PROT_EXECUTE
;;


type load_command =
    LC_SEGMENT
  | LC_SYMTAB
  | LC_SYMSEG
  | LC_THREAD
  | LC_UNIXTHREAD
  | LC_LOADFVMLIB
  | LC_IDFVMLIB
  | LC_IDENT
  | LC_FVMFILE
  | LC_PREPAGE
  | LC_DYSYMTAB
  | LC_LOAD_DYLIB
  | LC_ID_DYLIB
  | LC_LOAD_DYLINKER
  | LC_ID_DYLINKER
  | LC_PREBOUND_DYLIB
  | LC_ROUTINES
  | LC_SUB_FRAMEWORK
  | LC_SUB_UMBRELLA
  | LC_SUB_CLIENT
  | LC_SUB_LIBRARY
  | LC_TWOLEVEL_HINTS
  | LC_PREBIND_CKSUM
  | LC_LOAD_WEAK_DYLIB
  | LC_SEGMENT_64
  | LC_ROUTINES_64
  | LC_UUID
  | LC_RPATH
  | LC_CODE_SIGNATURE
  | LC_SEGMENT_SPLIT_INFO
  | LC_REEXPORT_DYLIB
  | LC_LAZY_LOAD_DYLIB
  | LC_ENCRYPTION_INFO
;;


let cpu_type_code (cpu:cpu_type) : int64 =
  match cpu with
      CPU_TYPE_X86 -> 7L
    | CPU_TYPE_X86_64 -> Int64.logor 7L cpu_arch_abi64
    | CPU_TYPE_ARM -> 12L
    | CPU_TYPE_POWERPC -> 18L
;;

let cpu_subtype_code (cpu:cpu_subtype) : int64 =
  match cpu with
      CPU_SUBTYPE_X86_ALL -> 3L
    | CPU_SUBTYPE_X86_64_ALL -> 3L
    | CPU_SUBTYPE_ARM_ALL -> 0L
    | CPU_SUBTYPE_POWERPC_ALL -> 0L
;;


let vm_prot_code (vmp:vm_prot) : int64 =
  match vmp with
    VM_PROT_NONE -> 0L
  | VM_PROT_READ -> 1L
  | VM_PROT_WRITE -> 2L
  | VM_PROT_EXECUTE -> 4L
;;


let lc_req_dyld = 0x80000000L;;

let load_command_code (lc:load_command) =
  match lc with
    | LC_SEGMENT -> 0x1L
    | LC_SYMTAB -> 0x2L
    | LC_SYMSEG -> 0x3L
    | LC_THREAD -> 0x4L
    | LC_UNIXTHREAD -> 0x5L
    | LC_LOADFVMLIB -> 0x6L
    | LC_IDFVMLIB -> 0x7L
    | LC_IDENT -> 0x8L
    | LC_FVMFILE -> 0x9L
    | LC_PREPAGE -> 0xaL
    | LC_DYSYMTAB -> 0xbL
    | LC_LOAD_DYLIB -> 0xcL
    | LC_ID_DYLIB -> 0xdL
    | LC_LOAD_DYLINKER -> 0xeL
    | LC_ID_DYLINKER -> 0xfL
    | LC_PREBOUND_DYLIB -> 0x10L
    | LC_ROUTINES -> 0x11L
    | LC_SUB_FRAMEWORK -> 0x12L
    | LC_SUB_UMBRELLA -> 0x13L
    | LC_SUB_CLIENT -> 0x14L
    | LC_SUB_LIBRARY -> 0x15L
    | LC_TWOLEVEL_HINTS -> 0x16L
    | LC_PREBIND_CKSUM -> 0x17L
    | LC_LOAD_WEAK_DYLIB -> Int64.logor lc_req_dyld 0x18L
    | LC_SEGMENT_64 -> 0x19L
    | LC_ROUTINES_64 -> 0x1aL
    | LC_UUID -> 0x1bL
    | LC_RPATH -> Int64.logor lc_req_dyld 0x1cL
    | LC_CODE_SIGNATURE -> 0x1dL
    | LC_SEGMENT_SPLIT_INFO -> 0x1eL
    | LC_REEXPORT_DYLIB -> Int64.logor lc_req_dyld 0x1fL
    | LC_LAZY_LOAD_DYLIB -> 0x20L
    | LC_ENCRYPTION_INFO -> 0x21L
;;


let fixed_sz_string (sz:int) (str:string) : frag =
  if String.length str > sz
  then STRING (String.sub str 0 sz)
  else SEQ [| STRING str; PAD (sz - (String.length str)) |]
;;

type sect_type =
    S_REGULAR
  | S_ZEROFILL
  | S_CSTRING_LITERALS
  | S_4BYTE_LITERALS
  | S_8BYTE_LITERALS
  | S_LITERAL_POINTERS
  | S_NON_LAZY_SYMBOL_POINTERS
  | S_LAZY_SYMBOL_POINTERS
  | S_SYMBOL_STUBS
  | S_MOD_INIT_FUNC_POINTERS
  | S_MOD_TERM_FUNC_POINTERS
  | S_COALESCED
  | S_GB_ZEROFILL
  | S_INTERPOSING
  | S_16BYTE_LITERALS
  | S_DTRACE_DOF
  | S_LAZY_DYLIB_SYMBOL_POINTERS
;;

let sect_type_code (s:sect_type) : int64 =
  match s with
    S_REGULAR -> 0x0L
  | S_ZEROFILL -> 0x1L
  | S_CSTRING_LITERALS -> 0x2L
  | S_4BYTE_LITERALS -> 0x3L
  | S_8BYTE_LITERALS -> 0x4L
  | S_LITERAL_POINTERS -> 0x5L
  | S_NON_LAZY_SYMBOL_POINTERS -> 0x6L
  | S_LAZY_SYMBOL_POINTERS -> 0x7L
  | S_SYMBOL_STUBS -> 0x8L
  | S_MOD_INIT_FUNC_POINTERS -> 0x9L
  | S_MOD_TERM_FUNC_POINTERS -> 0xaL
  | S_COALESCED -> 0xbL
  | S_GB_ZEROFILL -> 0xcL
  | S_INTERPOSING -> 0xdL
  | S_16BYTE_LITERALS -> 0xeL
  | S_DTRACE_DOF -> 0xfL
  | S_LAZY_DYLIB_SYMBOL_POINTERS -> 0x10L
;;

type sect_attr =
    S_ATTR_PURE_INSTRUCTIONS
  | S_ATTR_NO_TOC
  | S_ATTR_STRIP_STATIC_SYMS
  | S_ATTR_NO_DEAD_STRIP
  | S_ATTR_LIVE_SUPPORT
  | S_ATTR_SELF_MODIFYING_CODE
  | S_ATTR_DEBUG
  | S_ATTR_SOME_INSTRUCTIONS
  | S_ATTR_EXT_RELOC
  | S_ATTR_LOC_RELOC
;;

let sect_attr_code (s:sect_attr) : int64 =
  match s with
    S_ATTR_PURE_INSTRUCTIONS -> 0x80000000L
  | S_ATTR_NO_TOC -> 0x40000000L
  | S_ATTR_STRIP_STATIC_SYMS -> 0x20000000L
  | S_ATTR_NO_DEAD_STRIP -> 0x10000000L
  | S_ATTR_LIVE_SUPPORT -> 0x08000000L
  | S_ATTR_SELF_MODIFYING_CODE -> 0x04000000L
  | S_ATTR_DEBUG -> 0x02000000L
  | S_ATTR_SOME_INSTRUCTIONS -> 0x00000400L
  | S_ATTR_EXT_RELOC -> 0x00000200L
  | S_ATTR_LOC_RELOC -> 0x00000100L
;;

type n_type =
  | N_EXT
  | N_UNDF
  | N_ABS
  | N_SECT
  | N_PBUD
  | N_INDIR
;;

let n_type_code (n:n_type) : int64 =
  match n with
      N_EXT -> 0x1L
    | N_UNDF -> 0x0L
    | N_ABS -> 0x2L
    | N_SECT -> 0xeL
    | N_PBUD -> 0xcL
    | N_INDIR -> 0xaL
;;


type n_desc_reference_type =
    REFERENCE_FLAG_UNDEFINED_NON_LAZY
  | REFERENCE_FLAG_UNDEFINED_LAZY
  | REFERENCE_FLAG_DEFINED
  | REFERENCE_FLAG_PRIVATE_DEFINED
  | REFERENCE_FLAG_PRIVATE_UNDEFINED_NON_LAZY
  | REFERENCE_FLAG_PRIVATE_UNDEFINED_LAZY
;;

let n_desc_reference_type_code (n:n_desc_reference_type) : int64 =
  match n with
      REFERENCE_FLAG_UNDEFINED_NON_LAZY -> 0x0L
    | REFERENCE_FLAG_UNDEFINED_LAZY -> 0x1L
    | REFERENCE_FLAG_DEFINED -> 0x2L
    | REFERENCE_FLAG_PRIVATE_DEFINED -> 0x3L
    | REFERENCE_FLAG_PRIVATE_UNDEFINED_NON_LAZY -> 0x4L
    | REFERENCE_FLAG_PRIVATE_UNDEFINED_LAZY -> 0x5L
;;

type n_desc_flags =
    REFERENCED_DYNAMICALLY
  | N_DESC_DISCARDED
  | N_NO_DEAD_STRIP
  | N_WEAK_REF
  | N_WEAK_DEF
;;

let n_desc_flags_code (n:n_desc_flags) : int64 =
  match n with
      REFERENCED_DYNAMICALLY -> 0x10L
    | N_DESC_DISCARDED -> 0x20L
    | N_NO_DEAD_STRIP -> 0x20L (* Yes, they reuse 0x20. *)
    | N_WEAK_REF -> 0x40L
    | N_WEAK_DEF -> 0x80L
;;

type n_desc_dylib_ordinal = int;;

type n_desc = (n_desc_dylib_ordinal *
                 (n_desc_flags list) *
                 n_desc_reference_type)
;;

let n_desc_code (n:n_desc) : int64 =
  let (dylib_ordinal, flags, ty) = n in
    Int64.logor
      (Int64.of_int (dylib_ordinal lsl 8))
      (Int64.logor
         (fold_flags n_desc_flags_code flags)
         (n_desc_reference_type_code ty))
;;


let macho_section_command
    (seg_name:string)
    (sect:(string * int * (sect_attr list) * sect_type * fixup))
    : frag =
  let (sect_name, sect_align, sect_attrs, sect_type, sect_fixup) = sect in
    SEQ [|
      fixed_sz_string 16 sect_name;
      fixed_sz_string 16 seg_name;
      WORD (TY_u32, M_POS sect_fixup);
      WORD (TY_u32, M_SZ sect_fixup);
      WORD (TY_u32, F_POS sect_fixup);
      WORD (TY_u32, IMM (Int64.of_int sect_align));
      WORD (TY_u32, IMM 0L); (* reloff *)
      WORD (TY_u32, IMM 0L); (* nreloc *)
      WORD (TY_u32, (IMM (Int64.logor (* flags (and attrs) *)
                            (fold_flags sect_attr_code sect_attrs)
                            (sect_type_code sect_type))));
      WORD (TY_u32, IMM 0L); (* reserved1 *)
      WORD (TY_u32, IMM 0L); (* reserved2 *)
  |]
;;

let macho_segment_command
    (seg_name:string)
    (seg_fixup:fixup)
    (maxprot:vm_prot list)
    (initprot:vm_prot list)
    (sects:(string * int * (sect_attr list) * sect_type * fixup) array)
    : frag =

  let cmd_fixup = new_fixup "segment command" in
  let cmd =
    SEQ [|
      WORD (TY_u32, IMM (load_command_code LC_SEGMENT));
      WORD (TY_u32, F_SZ cmd_fixup);
      fixed_sz_string 16 seg_name;
      WORD (TY_u32, M_POS seg_fixup);
      WORD (TY_u32, M_SZ seg_fixup);
      WORD (TY_u32, F_POS seg_fixup);
      WORD (TY_u32, F_SZ seg_fixup);
      WORD (TY_u32, IMM (fold_flags vm_prot_code maxprot));
      WORD (TY_u32, IMM (fold_flags vm_prot_code initprot));
      WORD (TY_u32, IMM (Int64.of_int (Array.length sects)));
      WORD (TY_u32, IMM 0L); (* Flags? *)
    |]
  in
    DEF (cmd_fixup,
         SEQ [|
           cmd;
           SEQ (Array.map (macho_section_command seg_name) sects);
         |])
;;

let macho_thread_command
    (entry:fixup)
    : frag =
  let cmd_fixup = new_fixup "thread command" in
  let x86_THREAD_STATE32 = 1L in
  let regs =
    [|
      WORD (TY_u32, IMM 0x0L); (* eax *)
      WORD (TY_u32, IMM 0x0L); (* ebx *)
      WORD (TY_u32, IMM 0x0L); (* ecx *)
      WORD (TY_u32, IMM 0x0L); (* edx *)

      WORD (TY_u32, IMM 0x0L); (* edi *)
      WORD (TY_u32, IMM 0x0L); (* esi *)
      WORD (TY_u32, IMM 0x0L); (* ebp *)
      WORD (TY_u32, IMM 0x0L); (* esp *)

      WORD (TY_u32, IMM 0x0L); (* ss *)
      WORD (TY_u32, IMM 0x0L); (* eflags *)
      WORD (TY_u32, M_POS entry); (* eip *)
      WORD (TY_u32, IMM 0x0L); (* cs *)

      WORD (TY_u32, IMM 0x0L); (* ds *)
      WORD (TY_u32, IMM 0x0L); (* es *)
      WORD (TY_u32, IMM 0x0L); (* fs *)
      WORD (TY_u32, IMM 0x0L); (* gs *)
    |]
  in
  let cmd =
    SEQ [|
      WORD (TY_u32, IMM (load_command_code LC_UNIXTHREAD));
      WORD (TY_u32, F_SZ cmd_fixup);
      WORD (TY_u32, IMM x86_THREAD_STATE32); (* "flavour" *)
      WORD (TY_u32, IMM (Int64.of_int (Array.length regs)));
      SEQ regs
    |]
  in
    DEF (cmd_fixup, cmd)
;;

let macho_dylinker_command : frag =
  let cmd_fixup = new_fixup "dylinker command" in
  let str_fixup = new_fixup "dylinker lc_str fixup" in
  let cmd =
    SEQ
      [|
        WORD (TY_u32, IMM (load_command_code LC_LOAD_DYLINKER));
        WORD (TY_u32, F_SZ cmd_fixup);

        (* see definition of lc_str; these things are weird. *)
        WORD (TY_u32, SUB (F_POS (str_fixup), F_POS (cmd_fixup)));
        DEF (str_fixup, ZSTRING "/usr/lib/dyld");
        ALIGN_FILE (4, MARK);
      |]
  in
    DEF (cmd_fixup, cmd);
;;

let macho_dylib_command (dylib:string) : frag =

  let cmd_fixup = new_fixup "dylib command" in
  let str_fixup = new_fixup "dylib lc_str fixup" in
  let cmd =
    SEQ
      [|
        WORD (TY_u32, IMM (load_command_code LC_LOAD_DYLIB));
        WORD (TY_u32, F_SZ cmd_fixup);

        (* see definition of lc_str; these things are weird. *)
        WORD (TY_u32, SUB (F_POS (str_fixup), F_POS (cmd_fixup)));

        WORD (TY_u32, IMM 0L); (* timestamp *)
        WORD (TY_u32, IMM 0L); (* current_version *)
        WORD (TY_u32, IMM 0L); (* compatibility_version *)

        (* Payload-and-alignment of an lc_str goes at end of command. *)
        DEF (str_fixup, ZSTRING dylib);
        ALIGN_FILE (4, MARK);

      |]
  in
    DEF (cmd_fixup, cmd)
;;


let macho_symtab_command
    (symtab_fixup:fixup)
    (nsyms:int64)
    (strtab_fixup:fixup)
    : frag =
  let cmd_fixup = new_fixup "symtab command" in
  let cmd =
    SEQ
      [|
        WORD (TY_u32, IMM (load_command_code LC_SYMTAB));
        WORD (TY_u32, F_SZ cmd_fixup);
        
        WORD (TY_u32, F_POS symtab_fixup); (* symoff *)
        WORD (TY_u32, IMM nsyms);          (* nsyms *)

        WORD (TY_u32, F_POS strtab_fixup); (* stroff *)
        WORD (TY_u32, F_SZ strtab_fixup);  (* strsz *)
      |]
  in
    DEF (cmd_fixup, cmd)
;;

let macho_dysymtab_command
    (defined_syms_index:int64)
    (defined_syms_count:int64)
    (undefined_syms_index:int64)
    (undefined_syms_count:int64)
    (indirect_symtab_fixup:fixup)  : frag =
  let cmd_fixup = new_fixup "dysymtab command" in
  let cmd =
    SEQ
      [|
        WORD (TY_u32, IMM (load_command_code LC_DYSYMTAB));
        WORD (TY_u32, F_SZ cmd_fixup);
        
        WORD (TY_u32, IMM 0L); (* ilocalsym *)
        WORD (TY_u32, IMM 0L); (* nlocalsym *)

        WORD (TY_u32, IMM defined_syms_index); (* iextdefsym *)
        WORD (TY_u32, IMM defined_syms_count); (* nextdefsym *)

        WORD (TY_u32, IMM undefined_syms_index); (* iundefsym *)
        WORD (TY_u32, IMM undefined_syms_count); (* nundefsym *)

        WORD (TY_u32, IMM 0L); (* tocoff *)
        WORD (TY_u32, IMM 0L); (* ntoc *)

        WORD (TY_u32, IMM 0L); (* modtaboff *)
        WORD (TY_u32, IMM 0L); (* nmodtab *)

        WORD (TY_u32, IMM 0L); (* extrefsymoff *)
        WORD (TY_u32, IMM 0L); (* nextrefsyms *)

        WORD (TY_u32, F_POS indirect_symtab_fixup); (* indirectsymoff *)
        WORD (TY_u32, IMM undefined_syms_count);    (* nindirectsyms *)

        WORD (TY_u32, IMM 0L); (* extreloff *)
        WORD (TY_u32, IMM 0L); (* nextrel *)

        WORD (TY_u32, IMM 0L); (* locreloff *)
        WORD (TY_u32, IMM 0L); (* nlocrel *)
      |]
  in
    DEF (cmd_fixup, cmd)
;;

let macho_header_32
    (cpu:cpu_type)
    (sub:cpu_subtype)
    (ftype:file_type)
    (flags:file_flag list)
    (loadcmds:frag array) : frag =
  let load_commands_fixup = new_fixup "load commands" in
  let cmds = DEF (load_commands_fixup, SEQ loadcmds) in
    SEQ
    [|
      WORD (TY_u32, IMM mh_magic);
      WORD (TY_u32, IMM (cpu_type_code cpu));
      WORD (TY_u32, IMM (cpu_subtype_code sub));
      WORD (TY_u32, IMM (file_type_code ftype));
      WORD (TY_u32, IMM (Int64.of_int (Array.length loadcmds)));
      WORD (TY_u32, F_SZ load_commands_fixup);
      WORD (TY_u32, IMM (fold_flags file_flag_code flags));
      cmds
    |]
;;

let emit_file
    (sess:Session.sess)
    (code:Asm.frag)
    (data:Asm.frag)
    (sem:Semant.ctxt)
    (dwarf:Dwarf.debug_records)
    : unit =

  (* FIXME: alignment? *)

  let mh_execute_header_fixup = new_fixup "__mh_execute header" in

  let nxargc_fixup = (Semant.export sem SEG_data "NXArgc") in
  let nxargv_fixup = (Semant.export sem SEG_data "NXArgv") in
  let progname_fixup = (Semant.export sem SEG_data "__progname") in
  let environ_fixup = (Semant.export sem SEG_data "environ") in
  let exit_fixup = (Semant.import sem LIB_c "exit") in
  let rust_start_fixup = (Semant.import sem LIB_rustrt "rust_start") in

  let start_fixup = new_fixup "start function entry" in

  let text_sect_align_log2 = 2 in
  let data_sect_align_log2 = 2 in

  let seg_align = 0x1000 in
  let text_sect_align = 2 lsl text_sect_align_log2 in
  let data_sect_align = 2 lsl data_sect_align_log2 in

  let align_both align i =
    ALIGN_FILE (align,
                (ALIGN_MEM (align, i)))
  in

  let def_aligned a f i =
    align_both a
      (SEQ [| DEF(f, i);
              (align_both a MARK)|])
  in

  (* Sections in the text segment. *)
  let text_section_fixup = new_fixup "__text section" in
  let text_section = def_aligned text_sect_align text_section_fixup code in

  (* Sections in the data segment. *)
  let data_section_fixup = new_fixup "__data section" in
  let const_section_fixup = new_fixup "__const section" in
  let bss_section_fixup = new_fixup "__bss section" in
  let nl_symbol_ptr_section_fixup = new_fixup "__nl_symbol_ptr section" in

  let data_section = def_aligned data_sect_align data_section_fixup data in
  let const_section = def_aligned data_sect_align const_section_fixup (SEQ [| |]) in
  let bss_section = def_aligned data_sect_align bss_section_fixup (SEQ [| |]) in

  (* Officially, Apple doesn't support DWARF sections like this. Whatever. *)
  let debug_info_section =
    def_aligned data_sect_align
      sem.Semant.ctxt_debug_info_fixup
      dwarf.Dwarf.debug_info
  in
  let debug_abbrev_section =
    def_aligned data_sect_align
      sem.Semant.ctxt_debug_abbrev_fixup
      dwarf.Dwarf.debug_abbrev
  in


  (* String, symbol and parallel "nonlazy-pointer" tables. *)
  let symtab_fixup = new_fixup "symtab" in
  let strtab_fixup = new_fixup "strtab" in

  let symbol_nlist_entry
      (sect_index:int)
      (nty:n_type list)
      (nd:n_desc)
      (nv:Asm.expr64)
      : (frag * fixup) =
    let strtab_entry_fixup = new_fixup "strtab entry" in
      (SEQ
         [|
           WORD (TY_u32, SUB ((F_POS strtab_entry_fixup), (F_POS strtab_fixup)));
           BYTE (Int64.to_int (fold_flags n_type_code nty));
           BYTE sect_index;
           WORD (TY_u16, IMM (n_desc_code nd));
           WORD (TY_u32, nv);
         |], strtab_entry_fixup)
  in


  let sect_symbol_nlist_entry (sect_index:int) (fixup_to_use:fixup) : (frag * fixup) =
    let nty = [ N_SECT; N_EXT ] in
    let nd = (0, [], REFERENCE_FLAG_UNDEFINED_NON_LAZY) in
      symbol_nlist_entry sect_index nty nd (M_POS fixup_to_use)
  in

  let indirect_symbol_nlist_entry (dylib_index:int) : (frag * fixup) =
    let nty = [ N_UNDF; N_EXT ] in
    let nd = (dylib_index, [], REFERENCE_FLAG_UNDEFINED_NON_LAZY) in
      symbol_nlist_entry 0 nty nd (IMM 0L)
  in

  let absolute_symbol_nlist_entry (fixup_to_use:fixup) : (frag * fixup) =
    let nty = [ N_ABS; N_EXT ] in
    let nd = (0, [], REFERENCE_FLAG_DEFINED) in
      symbol_nlist_entry 0 nty nd (M_POS fixup_to_use)
  in

  let absolute_private_symbol_nlist_entry (fixup_to_use:fixup) : (frag * fixup) =
    let nty = [ N_ABS; N_EXT ] in
    let nd = (0, [], REFERENCE_FLAG_PRIVATE_DEFINED) in
      symbol_nlist_entry 0 nty nd (M_POS fixup_to_use)
  in

  let indirect_symbols =
    Array.of_list
      (List.concat
         (List.map
            (fun (lib, tab) ->
               (List.map
                  (fun (name,fix) -> (lib,name,fix))
                  (htab_pairs tab)))
            (htab_pairs sem.Semant.ctxt_imports)))
  in

  let exported_symbols =
    Array.of_list
      (List.concat
         (List.map
            (fun (seg, tab) ->
               (List.map
                  (fun (name, fix) -> (seg,name,fix))
                  (htab_pairs tab)))
            (htab_pairs sem.Semant.ctxt_exports)))
  in

  let dylib_index (lib:import_lib) : int =
    match lib with
        LIB_rustrt -> 1
      | LIB_c -> 2
  in

  (* Make undef symbols for imports. *)
  let (symbols:(string * (frag * fixup)) array) =
    Array.map (fun (lib,name,_) ->
                 ("_" ^ name,
                  indirect_symbol_nlist_entry (dylib_index lib)))
      indirect_symbols
  in

  (* Make symbols for exports. *)
  let (symbols:(string * (frag * fixup)) array) =
    Array.append symbols
      (Array.map (fun (seg,name,fix) ->
                    ("_" ^ name,
                     sect_symbol_nlist_entry
                       (match seg with
                            SEG_text -> 1
                          | SEG_data -> 2)
                       fix))
         exported_symbols)
  in

  (* Make private symbols for items. *)
  let (symbols:(string * (frag * fixup)) array) =
    Array.append symbols
      (Array.map (fun code ->
                    let fix = code.Semant.code_fixup in
                      ("_" ^ fix.fixup_name,
                       absolute_private_symbol_nlist_entry fix))
         (Array.of_list (htab_vals sem.Semant.ctxt_all_item_code)))
  in

  (* Make private symbols for glue. *)
  let (symbols:(string * (frag * fixup)) array) =
    Array.append symbols
      (Array.map (fun (g,code) ->
                    let fix = code.Semant.code_fixup in
                      (Semant.glue_str sem g,
                       absolute_private_symbol_nlist_entry fix))
         (Array.of_list (htab_pairs sem.Semant.ctxt_glue_code)))
  in

  let (symbols:(string * (frag * fixup)) array) =
    Array.append symbols
                 [|
                   ("__mh_execute_header", absolute_symbol_nlist_entry mh_execute_header_fixup);
                 |]
  in

  let indirect_symtab_fixup = new_fixup "indirect symbol table" in
  let indirect_symtab =
    DEF (indirect_symtab_fixup,
         SEQ (Array.mapi
                (fun i _ -> WORD(TY_u32, IMM (Int64.of_int i)))
                indirect_symbols))
  in

  let nl_symbol_ptr_section =
    def_aligned data_sect_align nl_symbol_ptr_section_fixup
      (SEQ (Array.map
              (fun (_, _, fix) ->
                 DEF(fix, WORD(TY_u32, IMM 0L)))
              indirect_symbols))
  in
  let strtab = DEF (strtab_fixup,
                    SEQ (Array.map
                           (fun (name, (_, fix)) -> DEF(fix, ZSTRING name))
                           symbols))
  in
  let symtab = DEF (symtab_fixup,
                    SEQ (Array.map (fun (_, (frag, _)) -> frag) symbols))
  in


  (* Segments. *)
  let zero_segment_fixup = new_fixup "__PAGEZERO segment" in
  let text_segment_fixup = new_fixup "__TEXT segment" in
  let data_segment_fixup = new_fixup "__DATA segment" in
  let dwarf_segment_fixup = new_fixup "__DWARF segment" in
  let linkedit_segment_fixup = new_fixup "__LINKEDIT segment" in

  let load_commands =
    [|
      macho_segment_command "__PAGEZERO" zero_segment_fixup
        [] [] [||];

      macho_segment_command "__TEXT" text_segment_fixup
        [VM_PROT_READ; VM_PROT_EXECUTE]
        [VM_PROT_READ; VM_PROT_EXECUTE]
        [|
          ("__text", text_sect_align_log2, [], S_REGULAR, text_section_fixup)
        |];

      macho_segment_command "__DATA" data_segment_fixup
        [VM_PROT_READ; VM_PROT_WRITE]
        [VM_PROT_READ; VM_PROT_WRITE]
        [|
          ("__data", data_sect_align_log2, [], S_REGULAR, data_section_fixup);
          ("__const", data_sect_align_log2, [], S_REGULAR, const_section_fixup);
          ("__bss", data_sect_align_log2, [], S_REGULAR, bss_section_fixup);
          ("__nl_symbol_ptr", data_sect_align_log2,
           [], S_NON_LAZY_SYMBOL_POINTERS, nl_symbol_ptr_section_fixup)
        |];

      macho_segment_command "__DWARF" dwarf_segment_fixup
        [VM_PROT_READ]
        [VM_PROT_READ]
        [|
          ("__debug_info", data_sect_align_log2, [], S_REGULAR, sem.Semant.ctxt_debug_info_fixup);
          ("__debug_abbrev", data_sect_align_log2, [], S_REGULAR, sem.Semant.ctxt_debug_abbrev_fixup);
        |];

      macho_segment_command "__LINKEDIT" linkedit_segment_fixup
        [VM_PROT_READ]
        [VM_PROT_READ]
        [|
        |];

      macho_symtab_command
        symtab_fixup (Int64.of_int (Array.length symbols)) strtab_fixup;

      (* These index-and-count numbers must match the 'symbols' table above.*)
      macho_dysymtab_command 2L 5L 0L 2L indirect_symtab_fixup;

      macho_dylinker_command;

      macho_dylib_command "librustrt.dylib";

      macho_dylib_command "/usr/lib/libSystem.B.dylib";

      macho_thread_command start_fixup
    |]
  in

  let header_and_commands =
    macho_header_32
      CPU_TYPE_X86
      CPU_SUBTYPE_X86_ALL
      MH_EXECUTE
      [ MH_BINDATLOAD; MH_DYLDLINK; MH_TWOLEVEL ]
      load_commands
  in

  let objfile_start e =
    Il.emit_full e (Some start_fixup) Il.Dead;

    (* zero marks the bottom of the frame chain. *)
    Il.emit e (Il.Push (X86.imm (Asm.IMM 0L)));
    Il.emit e (Il.umov (X86.rc X86.ebp) (X86.ro X86.esp));

    (* 16-byte align stack for SSE. *)
    Il.emit e (Il.binary Il.AND (X86.rc X86.esp) (X86.ro X86.esp)
                 (X86.imm (Asm.IMM 0xfffffffffffffff0L)));

    (* Store argc. *)
    Il.emit e (Il.umov (X86.rc X86.ebx) (X86.c (X86.word_n (Il.Hreg X86.ebp) 1)));
    Il.emit e (Il.umov (X86.word_at_abs (Asm.M_POS nxargc_fixup)) (X86.ro X86.ebx));

    (* Store argv. *)
    Il.emit e (Il.lea (X86.rc X86.ecx) (Il.RegIn (Il.Hreg X86.ebp, Some (X86.word_off_n 2))));
    Il.emit e (Il.umov (X86.word_at_abs (Asm.M_POS nxargv_fixup)) (X86.ro X86.ebx));

    (* Calculte and store envp. *)
    Il.emit e (Il.binary Il.ADD (X86.rc X86.ebx) (X86.ro X86.ebx) (X86.imm (Asm.IMM 1L)));
    Il.emit e (Il.binary Il.UMUL (X86.rc X86.ebx) (X86.ro X86.ebx) (X86.imm (Asm.IMM X86.word_sz)));
    Il.emit e (Il.binary Il.ADD (X86.rc X86.ebx) (X86.ro X86.ebx) (X86.ro X86.ecx));
    Il.emit e (Il.umov (X86.word_at_abs (Asm.M_POS environ_fixup)) (X86.ro X86.ebx));

    (* Push 16 bytes to preserve SSE alignment. *)
    Il.emit e (Il.Push (X86.imm (Asm.IMM 0L)));
    Il.emit e (Il.Push (X86.imm (Asm.IMM 0L)));
    Il.emit e (Il.Push (X86.imm (Asm.M_POS sem.Semant.ctxt_crate_fixup)));
    Il.emit e (Il.Push (X86.imm (Asm.M_POS sem.Semant.ctxt_main_fn_fixup)));
    Il.emit e (Il.call (X86.rc X86.eax) (Il.indirect_code_ptr rust_start_fixup));
    Il.emit e (Il.Pop (X86.rc X86.ecx));
    Il.emit e (Il.Push (X86.ro X86.eax));
    Il.emit e (Il.call (X86.rc X86.eax) (Il.indirect_code_ptr exit_fixup));
    Il.emit e (Il.Pop (X86.rc X86.ecx));
    Il.emit e (Il.Pop (X86.rc X86.ecx));
    Il.emit e (Il.Pop (X86.rc X86.ecx));
    Il.emit e (Il.Pop (X86.rc X86.ecx));

    Il.emit e Il.Ret;
  in

  let text_segment =
    let e = X86.new_emitter () in
      objfile_start e;
      def_aligned seg_align text_segment_fixup
        (SEQ [|
           DEF (mh_execute_header_fixup, header_and_commands);
           X86.frags_of_emitted_quads sess e;
           text_section;
           align_both seg_align MARK;
         |]);
  in

  let zero_segment = align_both seg_align
    (SEQ [| MEMPOS 0L; DEF (zero_segment_fixup, SEQ [| MEMPOS 0x1000L; MARK |] ) |])
  in

  let data_segment = def_aligned seg_align data_segment_fixup
    (SEQ [|
       DEF(nxargc_fixup, WORD (TY_u32, IMM 0L));
       DEF(nxargv_fixup, WORD (TY_u32, IMM 0L));
       DEF(environ_fixup, WORD (TY_u32, IMM 0L));
       DEF(progname_fixup, WORD (TY_u32, IMM 0L));
       data_section;
       const_section;
       bss_section;
       nl_symbol_ptr_section
     |])
  in

  let dwarf_segment = def_aligned seg_align dwarf_segment_fixup
    (SEQ [|
       debug_info_section;
       debug_abbrev_section;
     |])
  in

  let linkedit_segment = def_aligned seg_align linkedit_segment_fixup
    (SEQ [|
       symtab;
       strtab;
       indirect_symtab;
     |])
  in

  let segments =
    SEQ [|
      zero_segment;
      text_segment;
      data_segment;
      dwarf_segment;
      linkedit_segment;
    |]
  in

  let buf = Buffer.create 16 in
  let out = open_out_bin sess.Session.sess_out in
    resolve_frag sess segments;
    lower_frag ~sess ~lsb0: true ~buf ~it: segments;
    Buffer.output_buffer out buf;
    flush out;
    close_out out
;;

let get_sections (ar:asm_reader) : (string,(int*int)) Hashtbl.t =
  let sects = Hashtbl.create 0 in
  let magic = ar.asm_get_u32() in
  let _ = assert (magic = (Int64.to_int mh_magic)) in
  let _ = ar.asm_adv_u32() in (* cpu type *)
  let _ = ar.asm_adv_u32() in (* cpu subtype *)
  let _ = ar.asm_adv_u32() in (* file type *)
  let n_load_cmds = ar.asm_get_u32() in
  let _ = ar.asm_adv_u32() in
  let _ = Printf.printf "Mach-o file with %d load commands\n" n_load_cmds in
  let _ = ar.asm_adv_u32() in (* flags *)
  let lc_seg = Int64.to_int (load_command_code LC_SEGMENT) in
    for i = 0 to n_load_cmds - 1 do
      let load_cmd_code = ar.asm_get_u32() in
      let load_cmd_size = ar.asm_get_u32() in
      let _ = Printf.printf "load command %d:\n" i in
        if load_cmd_code != lc_seg
        then ar.asm_adv (load_cmd_size - 8)
        else
          begin
            let seg_name = ar.asm_get_zstr_padded 16 in
            let _ = Printf.printf "LC_SEGMENT %s\n" seg_name in
            let _ = ar.asm_adv_u32() in (* seg mem pos *)
            let _ = ar.asm_adv_u32() in (* seg mem sz *)
            let _ = ar.asm_adv_u32() in (* seg file pos *)
            let _ = ar.asm_adv_u32() in (* seg file sz *)
            let _ = ar.asm_adv_u32() in (* maxprot *)
            let _ = ar.asm_adv_u32() in (* initprot *)
            let n_sects = ar.asm_get_u32() in
            let _ = ar.asm_get_u32() in (* flags *)
            let _ = Printf.printf "%d sections\n" in
              for j = 0 to n_sects - 1 do
                let sect_name = ar.asm_get_zstr_padded 16 in
                let _ = ar.asm_adv 16 in (* seg name *)
                let _ = ar.asm_adv_u32() in (* sect mem pos *)
                let m_sz = ar.asm_get_u32() in
                let f_pos = ar.asm_get_u32() in
                let _ = ar.asm_adv_u32() in (* sect align *)
                let _ = ar.asm_adv_u32() in (* reloff *)
                let _ = ar.asm_adv_u32() in (* nreloc *)
                let _ = ar.asm_adv_u32() in (* flags *)
                let _ = ar.asm_adv_u32() in (* reserved1 *)
                let _ = ar.asm_adv_u32() in (* reserved2 *)
                let _ =
                  Printf.printf
                    "  section %d: 0x%x - 0x%x %s \n"
                    j f_pos (f_pos + m_sz) sect_name
                in
                let len = String.length sect_name in
                let sect_name =
                  if (len > 2
                      && sect_name.[0] = '_'
                      && sect_name.[1] = '_')
                  then "." ^ (String.sub sect_name 2 (len-2))
                  else sect_name
                in
                  Hashtbl.add sects sect_name (f_pos, m_sz)
              done
          end
    done;
    sects
;;


(*
 * Local Variables:
 * fill-column: 70;
 * indent-tabs-mode: nil
 * buffer-file-coding-system: utf-8-unix
 * compile-command: "make -k -C ../.. 2>&1 | sed -e 's/\\/x\\//x:\\//g'";
 * End:
 *)
