;//--------------------------------------------------------------------------------
;// Tyra VU math macros
;//
;// The vector helpers the VU1 programs call. Written from the instruction set
;// described in the PS2 VU User's Manual; each macro lists the VU features it
;// relies on and the registers it clobbers.
;//
;// Licensed under Apache License 2.0
;//--------------------------------------------------------------------------------

;//--------------------------------------------------------------------------------
;// MatrixLoad - loads a 4x4 matrix (four consecutive quadwords, one per row)
;// from VU memory at "vumemlocation" + "offset" into the rows matrix[0..3].
;// Uses: LQ.
;//--------------------------------------------------------------------------------
#macro MatrixLoad: matrix, offset, vumemlocation
   lq          matrix[0],   offset+0(vumemlocation)
   lq          matrix[1],   offset+1(vumemlocation)
   lq          matrix[2],   offset+2(vumemlocation)
   lq          matrix[3],   offset+3(vumemlocation)
#endmacro

;//--------------------------------------------------------------------------------
;// MatrixMultiply - matresult = matleft * matright, row by row: result row r is
;// the sum over c of (matleft[r].c * matright[c]).
;// Uses: MULA / MADDA / MADD with a broadcast field. Clobbers: ACC.
;//--------------------------------------------------------------------------------
#macro MatrixMultiply: matresult, matleft, matright
   mula        acc,          matright[0],  matleft[0][x]
   madda       acc,          matright[1],  matleft[0][y]
   madda       acc,          matright[2],  matleft[0][z]
   madd        matresult[0], matright[3],  matleft[0][w]

   mula        acc,          matright[0],  matleft[1][x]
   madda       acc,          matright[1],  matleft[1][y]
   madda       acc,          matright[2],  matleft[1][z]
   madd        matresult[1], matright[3],  matleft[1][w]

   mula        acc,          matright[0],  matleft[2][x]
   madda       acc,          matright[1],  matleft[2][y]
   madda       acc,          matright[2],  matleft[2][z]
   madd        matresult[2], matright[3],  matleft[2][w]

   mula        acc,          matright[0],  matleft[3][x]
   madda       acc,          matright[1],  matleft[3][y]
   madda       acc,          matright[2],  matleft[3][z]
   madd        matresult[3], matright[3],  matleft[3][w]
#endmacro

;//--------------------------------------------------------------------------------
;// MatrixMultiplyVertex - vertexresult = vertex transformed by "matrix": the sum
;// of the four matrix rows, each scaled by one component of the vertex.
;// Uses: MULA / MADDA / MADD with a broadcast field. Clobbers: ACC.
;//--------------------------------------------------------------------------------
#macro MatrixMultiplyVertex: vertexresult, matrix, vertex
   mula        acc,          matrix[0],    vertex[x]
   madda       acc,          matrix[1],    vertex[y]
   madda       acc,          matrix[2],    vertex[z]
   madd        vertexresult, matrix[3],    vertex[w]
#endmacro

;//--------------------------------------------------------------------------------
;// VertexPersCorr - perspective divide: vertexoutput.xyz = vertex.xyz / vertex.w.
;// The divide unit computes Q = 1.0 / vertex.w (vf00.w is the constant 1.0) and the
;// result is vertex.xyz * Q. w is left untouched in vertexoutput.
;// Uses: DIV, MULQ. Clobbers: Q. The value stays in Q for later macros that need it.
;//--------------------------------------------------------------------------------
#macro VertexPersCorr: vertexoutput, vertex
   div         q,            vf00[w],      vertex[w]
   mulq.xyz    vertexoutput, vertex,       q
#endmacro

;//--------------------------------------------------------------------------------
;// ResetClipFlags - zeroes the clip flag register, so that the flags read by
;// PerformClipCheck only describe the vertices tested after this point.
;// Uses: FCSET.
;//--------------------------------------------------------------------------------
#macro ResetClipFlags
   fcset       0x000000
#endmacro

;//--------------------------------------------------------------------------------
;// PerformClipCheck - tests one vertex against the six clip planes (CLIPw compares
;// vertex.xyz with vertex.w and records the result in the clip flag register, which
;// keeps the results of the last three vertices). FCAND then tests those 18 bits
;// against a mask: VI01 becomes 1 if any vertex is outside a plane, else 0.
;// The value 0x7FFF + VI01 is 0x8000 (bit 15 set) or 0x7FFF (clear). It is stored in
;// the w field of the vertex's output slot, where bit 15 is the GS "ADC" bit that
;// makes the GS skip the triangle. Call it once per vertex of a triangle.
;// Uses: CLIPw, FCAND, IADDIU, ISW. Clobbers: VI01 and the temporary adcBit.
;//--------------------------------------------------------------------------------
#macro PerformClipCheck: t_vertex, t_destAddress, t_destAddressOffset
   clipw.xyz   t_vertex,     t_vertex[w]
   fcand       VI01,         0x3FFFF
   iaddiu      adcBit,       VI01,         0x7FFF
   isw.w       adcBit,       t_destAddressOffset(t_destAddress)
#endmacro

;//--------------------------------------------------------------------------------
;// ScaleVertexToGSFormat - maps a perspective-divided vertex to GS screen space and
;// converts it to the GS 12.4 fixed point format: xyz = xyz * scale + scale, then
;// FTOI4 (float to integer with 4 fractional bits). ACC is first loaded with
;// scale * 1.0 (vf00.w) so the multiply-add adds it.
;// Uses: MULA, MADD, FTOI4. Clobbers: ACC.
;//--------------------------------------------------------------------------------
#macro ScaleVertexToGSFormat: t_scale, t_vertex
   mula.xyz    acc,          t_scale,      vf00[w]
   madd.xyz    t_vertex,     t_vertex,     t_scale
   ftoi4.xyz   t_vertex,     t_vertex
#endmacro

;//--------------------------------------------------------------------------------
;// PerformTexturePerspectiveCorrection - t_resultStq = t_stq * Q. Q must hold
;// 1 / w of the same vertex, so this has to come after VertexPersCorr for it.
;// Uses: MULQ.
;//--------------------------------------------------------------------------------
#macro PerformTexturePerspectiveCorrection: t_resultStq, t_stq
   mulq        t_resultStq,  t_stq,        q
#endmacro

;//--------------------------------------------------------------------------------
;// FixColor - prepares a color for the GS: clamps r, g and b to 0..255 (the I
;// register is loaded with 255, vf00.x supplies 0) and converts all four
;// components from float to integer without a fractional part.
;// Uses: LOI, MINI, MAX, FTOI0. Clobbers: I.
;//--------------------------------------------------------------------------------
#macro FixColor: t_color
   loi         255
   mini.xyz    t_color,      t_color,      i
   max.xyz     t_color,      t_color,      vf00[x]
   ftoi0       t_color,      t_color
#endmacro
