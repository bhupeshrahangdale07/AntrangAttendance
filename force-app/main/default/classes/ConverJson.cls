public class ConverJson {
    
    public static String convert(string JSONStr){
        
        String finalString = '';
        
        if(String.isNotBlank(JSONStr)){
            
            JSONStr = JSONStr.contains(':') ? JSONStr.replaceAll(':', ' : ') : JSONStr;
            JSONStr = JSONStr.contains(',') ? JSONStr.replaceAll(',', ' , ') : JSONStr;
            
            
            List<String> tempList = JSONStr.split(' ');
            Boolean gotCategory = false;
            Boolean isSkip = false;
            for(String str : tempList){
                
                Pattern nonAlphanumeric = Pattern.compile('[^a-zA-Z0-9]');
                Matcher matcher = nonAlphanumeric.matcher(str);
                
                str = matcher.replaceAll('').toLowercase();
                
                if(String.isNotBlank(str) && !str.containsIgnoreCase('child') && !UnwantedStrings.contains(str) && !isSkip){
                    //System.debug('String ---> ' + str);
                    
                  
                    if(TobeSkipStrings.contains(str)){
                        isSkip = true;
                        gotCategory = false;
                        if(!finalString.endsWith('\n')){
                            finalString += '\n';
                        }
                        
                        //System.debug('*** skip next to ---> ' + str);
                        
                    }else{
                        if(!str.containsIgnoreCase('category') && !gotCategory){
                            finalString += matcher.replaceAll('') + ' ';
                        }
                        
                        if(gotCategory){
                            
                            finalString += ' ' + matcher.replaceAll('');
                            
                        }
                        
                        if(str.containsIgnoreCase('category')){
                            gotCategory = true;
                            finalString += ':';
                        }
                    }
                     //System.debug('isSkip: ' + isSkip);
                    //System.debug('finalString: ' + finalString);
                }else{
                    if(String.isNotBlank(str) && isSkip){
                        isSkip = false;
                    }
                }
            }
            
            System.debug('####: \n' + finalString + '\n ####');
        }
        return finalString;
        
    }
    
    public static set<string> UnwantedStrings = new Set<String>{'child', 'parent'};
        public static set<string> TobeSkipStrings = new Set<String>{'input', 'intent'};
            }