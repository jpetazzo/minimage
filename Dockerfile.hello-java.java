FROM java
COPY hello.java .
RUN javac hello.java
CMD exec java -cp . hello
