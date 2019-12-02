--DB BMW

CREATE TABLE public.tb_cliente (
	nome                     varchar(60) NOT NULL,
	idade                    integer     NOT NULL,
	genero                   char(1)     NOT NULL,
	endereco                 varchar(20) NOT NULL,
	cidade                   varchar(10) NOT NULL,
	cep                      integer     NOT NULL,
	telefone_contato         integer     NOT NULL,
	id_cliente               integer     NOT NULL,
	CONSTRAINT tb_cliente_pk PRIMARY KEY (id_cliente)
);

CREATE TABLE public.tb_carros (
	id_carro integer NOT NULL,
	condição varchar(5) NOT NULL,
	cor varchar(10) NOT NULL,
	kilometragem float8 NOT NULL,
	ano_de_fabricacao integer NOT NULL,
	dt_revisao date NULL,
	largura float8 NOT NULL,
	comprimento float4 NOT NULL,
	altura float4 NOT NULL,
	comprimento_entre_eixos float4 NULL,
	"Motorização(cv)" integer NOT NULL,
	"tanque(L)" varchar NOT NULL,
	CONSTRAINT tb_carros_pk PRIMARY KEY (id_carro)
);

CREATE TABLE public.tb_venda (
	id_carro integer NOT NULL,
	id_cliente integer NULL,
	data_venda date NOT NULL,
	quantidade integer NOT NULL,
	valor float4 NOT NULL,
	CONSTRAINT tb_venda_fk   FOREIGN KEY (id_carro)   REFERENCES public.tb_carros(id_carro),
	CONSTRAINT tb_venda_fk_1 FOREIGN KEY (id_cliente) REFERENCES public.tb_cliente(id_cliente)
);
ALTER TABLE public.tb_venda DROP CONSTRAINT tb_venda_fk;
ALTER TABLE public.tb_venda ADD CONSTRAINT tb_venda_fk FOREIGN KEY (id_carro) REFERENCES public.tb_carros(id_carro);
ALTER TABLE public.tb_venda ADD CONSTRAINT tb_venda_fk_2 FOREIGN KEY (id_cliente) REFERENCES public.tb_cliente(id_cliente);
ALTER TABLE public.tb_venda DROP CONSTRAINT tb_venda_fk_2;
ALTER TABLE public.tb_venda DROP CONSTRAINT tb_venda_fk_1;
ALTER TABLE public.tb_venda ADD CONSTRAINT tb_venda_fk_1 FOREIGN KEY (id_cliente) REFERENCES public.tb_cliente(id_cliente);

CREATE OR REPLACE FUNCTION fn_alterar_usuario (p_opcao VARCHAR,p_nome VARCHAR, nome VARCHAR, novo_nome varchar,nova_idade integer, novo_genero char, novo_endereco varchar, novo_cidade varchar, novo_cep integer, novo_telefone_contato integer, novo_id_cliente integer) RETURNS TEXT AS
$$
  BEGIN 
     IF (p_opcao = 'I') THEN
	 	INSERT INTO tb_cliente VALUES (novo_nome, nova_idade, novo_genero, novo_endereco, novo_cidade, novo_cep, novo_telefone_contato, novo_id_cliente);
		RETURN 'Valor inserido com sucesso!';
	ELSIF (p_opcao = 'A') THEN	
		UPDATE 	tb_cliente SET  nome = novo_nome, idade = nova_idade, genero = novo_genero, endereco = novo_endereco, cidade = novo_cidade, cep = novo_cep, telefone_contato = novo_telefone_contato, id_cliente = novo_id_cliente WHERE nome = p_nome;
		RETURN 'valor alterado com sucesso';
	ELSIF (p_opcao = 'D') THEN
		DELETE FROM tb_cliente WHERE nome = p_nome;
		IF NOT  FOUND THEN
			RAISE EXCEPTION 'Cliente não encontrado';
		ELSE
			RETURN 'Cliente deletado com sucesso';
		END IF;
	ELSE
		RETURN 'A sua função não funcionou';
	END IF;
END	 
$$
LANGUAGE PLPGSQL;
