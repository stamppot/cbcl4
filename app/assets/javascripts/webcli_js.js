'use strict';

var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

var WebCLI = function () {
    function WebCLI() {
        _classCallCheck(this, WebCLI);

        var self = this;
        self.history = []; //Command history
        self.cmdOffset = 0; //Reverse offset into history

        self.createElements();
        self.wireEvents();
        self.showGreeting();
    }

    _createClass(WebCLI, [{
        key: 'wireEvents',
        value: function wireEvents() {
            var self = this;

            self.keyDownHandler = function (e) {
                self.onKeyDown(e);
            };
            self.clickHandler = function (e) {
                self.onClick(e);
            };

            document.addEventListener('keydown', self.keyDownHandler);
            self.ctrlEl.addEventListener('click', self.clickHandler);
        }
    }, {
        key: 'onClick',
        value: function onClick() {
            this.focus();
        }
    }, {
        key: 'onKeyDown',
        value: function onKeyDown(e) {
            var self = this,
                ctrlStyle = self.ctrlEl.style;

            //Ctrl + Backquote (Document)
            if (e.ctrlKey && e.keyCode == 192) {
                if (ctrlStyle.display == "none") {
                    ctrlStyle.display = "";
                    self.focus();
                } else {
                    ctrlStyle.display = "none";
                }
                return;
            }

            //Other keys (when input has focus)
            if (self.inputEl === document.activeElement) {
                switch (e.keyCode) {//http://keycode.info/
                    case 13:
                        //Enter
                        return self.runCmd();

                    case 38:
                        //Up
                        if (self.history.length + self.cmdOffset > 0) {
                            self.cmdOffset--;
                            self.inputEl.value = self.history[self.history.length + self.cmdOffset];
                            e.preventDefault();
                        }
                        break;

                    case 40:
                        //Down
                        if (self.cmdOffset < -1) {
                            self.cmdOffset++;
                            self.inputEl.value = self.history[self.history.length + self.cmdOffset];
                            e.preventDefault();
                        }
                        break;
                }
            }
        }
    }, {
        key: 'runCmd',
        value: function runCmd() {
            var self = this,
                txt = self.inputEl.value.trim();

            self.cmdOffset = 0; //Reset history index
            self.inputEl.value = ""; //Clear input
            self.writeLine(txt, "cmd"); //Write cmd to output
            if (txt === "") {
                return;
            } //If empty, stop processing
            self.history.push(txt); //Add cmd to history

            //Client command:
            var tokens = txt.split(" "),
                cmd = tokens[0].toUpperCase();
            var args = tokens.slice(1, tokens.length).join(" ");

            if (cmd === "CLS") {
                self.outputEl.innerHTML = "";return;
            }
            if (cmd === "IMG") {
                self.writeHTML("<img src='https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png'>");return;
            }
            if (cmd === "YOUTUBE") {
                self.writeHTML('<iframe width="560" height="315" src="https://www.youtube.com/embed/OJRpatLMUuE?autoplay=1" frameborder="0" allowfullscreen></iframe>');
                return;
            }
            if (cmd === "YT") {
                self.writeHTML('<iframe width="560" height="315" src="https://www.youtube.com/results?search_query=' + args + '?autoplay=1" frameborder="0" allowfullscreen></iframe>');
                return;
            }
            if (cmd === "GOOGLE") {
                self.writeHTML('<iframe width="560" height="315" src="https://www.google.com/?q=' + args + '" frameborder="0" allowfullscreen></iframe>');
                return;
            }

            //Server command:
            fetch("/console/command", {
                method: "post",
                headers: new Headers({ "Content-Type": "application/json" }),
                body: JSON.stringify({ cmd: cmd, cmdline: txt, args: args })
            }).then(function (r) {
                return r.json();
            }).then(function (result) {
                var output = result.output;
                var style = result.isError ? "error" : "ok";

                if (result.isHTML) {
                    self.writeHTML(output);
                } else {
                    self.writeLine(output, style);
                }
            }).catch(function () {
                self.writeLine("Error sending request to server", "error");
            });
        }
    }, {
        key: 'focus',
        value: function focus() {
            this.inputEl.focus();
        }
    }, {
        key: 'scrollToBottom',
        value: function scrollToBottom() {
            this.ctrlEl.scrollTop = this.ctrlEl.scrollHeight;
            console.log("scrollToBottom");
        }
    }, {
        key: 'newLine',
        value: function newLine() {
            this.outputEl.appendChild(document.createElement("br"));
            this.scrollToBottom();
        }
    }, {
        key: 'writeLine',
        value: function writeLine(txt, cssSuffix) {
            var span = document.createElement("span");
            cssSuffix = cssSuffix || "ok";
            span.className = "webcli-" + cssSuffix;
            span.innerText = txt;
            this.outputEl.appendChild(span);
            this.newLine();
            console.log("writeLine: " + txt);
        }
    }, {
        key: 'writeHTML',
        value: function writeHTML(markup) {
            var div = document.createElement("div");
            div.innerHTML = markup;
            this.outputEl.appendChild(div);
            this.newLine();
        }
    }, {
        key: 'showGreeting',
        value: function showGreeting() {
            this.writeLine("Web CLI [Version 0.0.1]", "cmd");
            this.newLine();
            console.log('showGreeting');
        }
    }, {
        key: 'createElements',
        value: function createElements() {
            var self = this,
                doc = document;

            //Create & store CLI elements
            self.ctrlEl = doc.createElement("div"); //CLI control (outer frame)
            self.outputEl = doc.createElement("div"); //Div holding console output
            self.inputEl = doc.createElement("input"); //Input control

            //Add classes
            self.ctrlEl.className = "webcli";
            self.outputEl.className = "webcli-output";
            self.inputEl.className = "webcli-input";

            //Add attribute
            self.inputEl.setAttribute("spellcheck", "false");

            //Assemble them
            self.ctrlEl.appendChild(self.outputEl);
            self.ctrlEl.appendChild(self.inputEl);

            //Hide ctrl & add to DOM
            // self.ctrlEl.style.display = "none";
            doc.body.appendChild(self.ctrlEl);

            console.log('created Elements');
        }
    }]);

    return WebCLI;
}();