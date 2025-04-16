({

// Your renderer method overrides go here

    rerender : function(cmp, helper){
        this.superRerender();
        // do custom rerendering here
        // cmp.set('v.questions',[]);
        console.log('The Componenet Re-rendered');
    },
    
    afterRender: function (component, helper) {
        this.superAfterRender();
        // interact with the DOM here
        console.log('The Componenet After-Render');
    },
    
    unrender: function () {
        this.superUnrender();
        // do custom unrendering here
        console.log('The Componenet UN-Render');
    }

})