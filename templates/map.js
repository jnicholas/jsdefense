(function(){dust.register("map",body_0);function body_0(chk,ctx){return chk.write("<table class=\"grid\" cellspacing=\"0\" cellpadding=\"0\">").section(ctx.get("tiles"),ctx,{"else":body_1,"block":body_2},null).write("</table>");}function body_1(chk,ctx){return chk.write("<p>Unable to Generate Tiles</p>");}function body_2(chk,ctx){return chk.helper("math",ctx,{"block":body_3},{"key":body_6,"method":"mod","operand":"20"});}function body_3(chk,ctx){return chk.helper("eq",ctx,{"else":body_4,"block":body_5},{"value":0});}function body_4(chk,ctx){return chk.write("<td>").partial("tile",ctx,null).write("</td>");}function body_5(chk,ctx){return chk.write("<tr><td>").partial("tile",ctx,null).write("</td>");}function body_6(chk,ctx){return chk.reference(ctx.get("$idx"),ctx,"h");}return body_0;})();