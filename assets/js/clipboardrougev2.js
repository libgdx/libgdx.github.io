/* https://github.com/dieghernan/mmistakes-clipboard/blob/master/assets/js/clipboardrougev2.js */

// Clipboard
// This makes the button blink 250 miliseconds

function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

async function buttonBlink(btn, style) {
  btn.classList.remove("btn-light");
  btn.classList.add(style);
  await sleep(250); //Blink ms
  btn.classList.remove(style);
  btn.classList.add("btn-light");
}
// End


// Select all pre codes
var codeChunk = document.querySelectorAll("pre");

// Loop to add buttons
for (var i = 0; i < codeChunk.length; i++) {

  var pre = codeChunk.item(i);
  var child = pre.firstElementChild;

  // Check if there is a child
  if (child !== null) {
    // Check if child is code 
    // tagName output is UPCASE

    if (child.tagName == "CODE") {

      var btn = document.createElement("button");
      // Prepare button
      btn.innerHTML = "<i class='far fa-copy'></i>"; // Icon to be displayed on the button

      // Inline styling - may be a new css class, to be added in the next section
      btn.style.position = "absolute";
      btn.style.right = "1em";

      // Button: CSS - Add new classes
      btn.classList.add("btn", "btn--primary");

      // Identifier for ClipboardJS
      btn.setAttribute("data-clipboard-copy", "");

      // aria-label: btn.setAttribute("aria-label", "Copy to clipboard");
      // etc.

      // Insert button
      pre.insertBefore(btn, pre.firstChild);
    }
  }
}
// End

// Copy to clipboard
var clipboard = new ClipboardJS("[data-clipboard-copy]", {
  target: function (trigger) {
    return trigger.nextElementSibling;
  }
});

// Messages and make the button blink
clipboard.on("success", function (e) {
  e.clearSelection();
  buttonBlink(e.trigger, "btn--success");
  //console.info("Action:", e.action);
  //console.info("Text:", e.text);
  //console.info("Trigger:", e.trigger);
});

clipboard.on("error", function (e) {
  e.clearSelection();
  buttonBlink(e.trigger, "btn--danger");
  //console.info("Action:", e.action);
  //console.info("Trigger:", e.trigger);
});
// Finish
