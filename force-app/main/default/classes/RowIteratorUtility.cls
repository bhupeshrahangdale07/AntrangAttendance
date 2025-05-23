public class RowIteratorUtility implements Iterator<String>, Iterable<String> {
	private String m_Data;
   private Integer m_index = 0;
   private String m_rowDelimiter = '\n';
   public List<String> returnList = new List<String>();

   public RowIteratorUtility(String fileData)
   {
      m_Data = fileData; 
   }
   public RowIteratorUtility(String fileData, String rowDelimiter)
   {
      m_Data = fileData; 
      m_rowDelimiter = rowDelimiter;
   }

   public Boolean hasNext()
   {
      return m_index < m_Data.length() ? true : false;
   }
   public String next()
   {     
      Integer key = m_Data.indexOf(m_rowDelimiter, m_index);

      if (key == -1)
        key = m_Data.length();

      String row = m_Data.subString(m_index, key);
      returnList.add(row);
      m_index = key + 1;
      return row;
   }
   public Iterator<String> Iterator()
   {
      return this;   
   }
}