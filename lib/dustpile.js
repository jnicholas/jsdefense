var input_path = "../templates/"; // directory of dust templates are stored with .dust file extension
var output_path = input_path;     // directory where the compiled .js files should be saved to
var FILE_EXT = ".dust";

var fs = require('fs');
var dust = require('dustjs-linkedin');
var timerId;

function compile_dust(file) {

  fs.readFile(input_path+file, function(err, data) {
    if (err) throw err;

    var newfile = file.split(FILE_EXT);
    var filename = newfile[0];
    newfile[newfile.length] = ".js";
    newfile = newfile.join("");

    var compiled = dust.compile(new String(data), filename);

    fs.writeFile(output_path+newfile, compiled, function(err) {
      if (err) throw err;
      console.log("Saved " + newfile);
    });
  });

}

fs.watch(input_path, function(evt, filename) {
  if (filename && filename.indexOf(FILE_EXT) > -1) {
    if (timerId) clearTimeout(timerId);    
    timerId = setTimeout(function(){ compile_dust(filename) }, 250);
  }
});