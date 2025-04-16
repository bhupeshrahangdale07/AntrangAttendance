({
	// Your renderer method overrides go here
    afterRender: function (component, helper) {
        
        this.superAfterRender();
        // interact with the DOM here
        window.onscroll = function() {myFunction()};
        
        var header = document.getElementById("loader");
        var sticky = header.offsetTop;
    
        function myFunction() {
          if (window.pageYOffset > sticky) {
            header.classList.add("sticky");
          } else {
            header.classList.remove("sticky");
          }
        }
    },
})